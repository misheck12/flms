class TeamDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_role

  def index
  end

  def show
    @team = current_user.team

    if @team.present?
      @players = @team.players
      @matches_home = @team.matches_home
      @matches_away = @team.matches_away
      @matches = @team.matches_home + @team.matches_away
    else
      flash[:alert] = 'Team data not found. Please set up your team.'
      redirect_to edit_user_registration_path
    end
  end

  private

  def ensure_team_role
    redirect_to root_path, alert: 'Unauthorized access.' unless current_user.team?
  end
end
