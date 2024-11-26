# app/controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  # Before actions to permit additional parameters
  before_action :configure_permitted_parameters, only: [:create, :update]

  # Ensure the create action is public by placing it above 'protected'
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
    else
      # Render the registration form again with errors
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # Permit additional parameters (name and role)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  # Redirect path after sign up (login page)
  def after_sign_up_path_for(resource)
    new_user_session_path
  end
end