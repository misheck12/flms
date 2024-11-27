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

  def after_sign_in_path_for(resource)
    case resource.role
    when 'team'
      team_dashboard_path  # Redirect team users to their dashboard
    when 'admin'
      admin_dashboard_path  # Redirect admin users to their dashboard
    when 'referee'
      referee_dashboard_path  # Redirect referee users to their dashboard
    else
      super # Use the default Devise redirect if the role is not recognized
    end
  end
end
