# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  # This before_action ensures that additional parameters are permitted for sign up and account update
  before_action :configure_permitted_parameters, only: [:create, :update]

  protected

  # Permit additional parameters for sign up and account update
  def configure_permitted_parameters
    # Permit the :role attribute for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])

    # Permit the :role attribute for account update (optional)
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end
end
