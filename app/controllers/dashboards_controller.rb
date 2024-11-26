class DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'dashboard'
  
  def show
    case current_user.role
    when 'admin'
      load_admin_dashboard
    when 'team'
      load_team_dashboard
    when 'referee'
      load_referee_dashboard
    else
      redirect_to root_path, alert: 'Unauthorized access.'
    end
  end

  private

  def load_admin_dashboard
    @pending_payments = Payment.where(status: :pending)
    @users = User.all
    # Add more admin-specific data here
  end

  def load_team_dashboard
    @team = current_user.team
    @players = @team.players
    @matches = @team.matches
    # Add more team-specific data here
  end

  def load_referee_dashboard
    @referee_profile = current_user.referee_profile
    @matches_to_manage = Match.where(referee_id: @referee_profile.id)
    # Add more referee-specific data here
  end
end
