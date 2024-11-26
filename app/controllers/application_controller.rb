class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:home] 

  def after_sign_in_path_for(resource)
    # Redirect based on user role
    case resource.role
    when 'admin'
      admin_dashboard_path
    when 'team'
      team_dashboard_path
    when 'referee'
      referee_dashboard_path
    else
      dashboard_path # Default dashboard for other roles
    end
  end
end