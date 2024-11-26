# app/controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  # Before actions to permit additional parameters
  before_action :configure_permitted_parameters, only: [:create, :update]

  # Override the create action to handle team creation
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        # Do NOT sign in the user automatically
        set_flash_message! :notice, :signed_up
        # Redirect to the login page
        redirect_to new_user_session_path
      else
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end

      # If the user has the 'team' role, create an associated Team
      if resource.team?
        create_associated_team(resource)
      end
    else
      # Render the registration form again with errors
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # Permit additional parameters (role and team attributes)
  def configure_permitted_parameters
    # Permit role during sign up and account update
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])

    # Permit role during account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])

    # Permit team-related parameters if the role is 'team'
    devise_parameter_sanitizer.permit(:sign_up, keys: team_signup_params) if you_select_team_role?
  end

  # Define which team parameters to permit
  def team_signup_params
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

  # Check if the user selected the 'team' role during sign up
  def you_select_team_role?
    params[:user][:role] == 'team'
  end

  # Redirect path after sign up (login page)
  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  private

  # Method to create an associated Team for users with the 'team' role
  def create_associated_team(user)
    team_params = {
      name: params[:user][:team_name],
      city: params[:user][:team_city],
      stadium: params[:user][:team_stadium],
      foundation_year: params[:user][:team_foundation_year],
      president: params[:user][:team_president],
      manager: params[:user][:team_manager],
      league_id: params[:user][:league_id],
      user: user
    }

    # Create the Team record
    team = Team.new(team_params)

    if team.save
      # Optionally, you can add a flash message indicating successful team creation
      flash[:notice] ||= "Registration successful. Please log in."
    else
      # If team creation fails, destroy the user to maintain data integrity
      user.destroy
      # Redirect back to the registration page with error messages
      flash[:alert] = "Team creation failed: #{team.errors.full_messages.join(', ')}"
      redirect_to new_user_registration_path and return
    end
  end
end