class TeamDashboardsController < ApplicationController
  before_action :authenticate_user! # Ensure any user is authenticated
  before_action :ensure_team_user # Restrict access to users with the "Team" role

  def index
    # Fetch the logged-in team user
    @team = current_user
    if @team.present?
      # Gather data specific to the team
      @players = @team.players || []
      @upcoming_matches = @team.upcoming_matches || []
      @past_matches = @team.past_matches || []
      @team_logo = @team.logo
    else
      flash[:alert] = 'No team data found. Please complete your team setup.'
      redirect_to edit_user_registration_path
    end
  end

  def show
    # Fetch detailed team data
    @team = current_user
    if @team.present?
      @players = @team.players || []
      @upcoming_matches = @team.upcoming_matches || []
      @past_matches = @team.past_matches || []
      @team_logo = @team.logo
    else
      flash[:alert] = 'No team data found. Please complete your team setup.'
      redirect_to edit_user_registration_path
    end
  end

  def edit_team_info
    @team = current_user
    if @team.nil?
      redirect_to root_path, alert: 'No associated team found.'
    end
  end

  def update_team_info
    @team = current_user
    if @team.update(team_params)
      redirect_to team_dashboard_path, notice: 'Team information updated successfully!'
    else
      flash.now[:alert] = 'Failed to update team information.'
      render :edit_team_info
    end
  end

  def view_league_standings
    @league = League.find(params[:league_id])
    @standings = @league.standings
  end

  def view_match_report
    @match = Match.find(params[:match_id])
    @report = @match.match_report
  end

  def contact_support
    # Placeholder for contacting support
  end

  private

  # Ensure that only "Team" users can access the dashboard
  def ensure_team_user
    redirect_to root_path, alert: 'Access denied! Only team accounts can view this dashboard.' unless current_user&.team?
  end

  # Strong parameters for updating team data
  def team_params
    params.require(:team).permit(:name, :logo, :contact_email, :contact_phone, :description)
  end
end
