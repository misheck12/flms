# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  # Override the create action to handle team creation
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?

      if resource.team?
        # Handle team creation for users with the 'team' role
        create_associated_team(resource)
      end

      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          redirect_to new_user_session_path
        else
          expire_data_after_sign_in!
          redirect_to after_inactive_sign_up_path_for(resource)
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # Permit additional parameters during sign-up and account updates
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role] + team_signup_params_if_applicable)
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  # Permit team-related parameters if the 'team' role is selected
  def team_signup_params_if_applicable
    return [] unless you_select_team_role?
    [
      :team_name,
      :team_city,
      :team_stadium,
      :team_foundation_year,
      :team_president,
      :team_manager,
      :league_id
    ]
  end

  # Check if the 'team' role was selected during sign-up
  def you_select_team_role?
    params[:user] && params[:user][:role] == 'team'
  end

  # Redirect to the login page after sign-up
  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  private

  # Create a Team for users with the 'team' role
  def create_associated_team(user)
    team_params = params.require(:user).permit(
      :team_name,
      :team_city,
      :team_stadium,
      :team_foundation_year,
      :team_president,
      :team_manager,
      :league_id
    ).merge(user: user)

    team = Team.new(team_params)

    unless team.save
      user.destroy
      flash[:alert] = "Team creation failed: #{team.errors.full_messages.to_sentence}"
      redirect_to new_user_registration_path and return
    end

    flash[:notice] ||= "Registration successful. Please log in."
  end
end
