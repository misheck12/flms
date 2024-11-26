class DashboardsController < ApplicationController

  layout 'dashboard'
  
 # app/controllers/dashboards_controller.rb
  before_action :authenticate_user!

  def show
    case current_user.role
    when 'admin'
      # Load admin-specific data
    when 'team'
      # Load team-specific data
    when 'referee'
      # Load referee-specific data
    else
      redirect_to root_path, alert: 'Unauthorized access.'
    end
  end
end
