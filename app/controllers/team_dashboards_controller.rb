class TeamDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_role

  def index
  end

  def show
    @team = current_user.team
    @players = @team.players
    @matches = @team.matches
    @matches_away = @team.matches_away
    @matches_home = @team.matches_home
    # Add more team-specific data here
  end

  private

  def ensure_team_role
    redirect_to root_path, alert: 'Unauthorized access.' unless current_user.team?
  end
end
