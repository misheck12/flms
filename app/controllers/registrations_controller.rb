# app/controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  # Before actions to permit additional parameters
  before_action :configure_permitted_parameters, only: [:create, :update]

  protected

  # Permit additional parameters (name and role)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end

  # Override the create method to prevent auto sign-in
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        # Do NOT sign in the user
        set_flash_message! :notice, :signed_up
        # Redirect to the login page
        respond_with resource, location: new_user_session_path
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      # If user failed to save, render the registration form again
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # Redirect path after sign up (login page)
  def after_sign_up_path_for(resource)
    new_user_session_path
  end
end