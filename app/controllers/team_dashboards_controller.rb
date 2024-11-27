class TeamDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_user
  before_action :set_team, only: [:show, :edit_team_info, :update_team_info]

  def index
    if @team.present?
      load_team_data
    else
      flash[:alert] = 'No team data found. Please complete your team setup.'
      redirect_to new_team_path # Redirect to team setup
    end
  end

  def show
    if @team.present?
      load_team_data
    else
      flash[:alert] = 'No team data found. Please complete your team setup.'
      redirect_to new_team_path # Redirect to team creation page
    end
  end

  def edit_team_info
    unless @team
      flash[:alert] = 'No associated team found. Please create a team first.'
      redirect_to new_team_path
    end
    # Renders edit_team_info.html.erb
  end

  def update_team_info
    if @team.update(team_params)
      redirect_to team_dashboard_path, notice: 'Team information updated successfully!'
    else
      flash.now[:alert] = 'Failed to update team information.'
      render :edit_team_info
    end
  end

  def view_league_standings
    @league = League.find_by(id: params[:league_id])
    if @league
      @standings = @league.standings
    else
      flash[:alert] = 'League not found.'
      redirect_back(fallback_location: team_dashboard_path)
    end
  end

  def view_match_report
    @match = Match.find_by(id: params[:match_id])
    if @match
      @report = @match.match_report
    else
      flash[:alert] = 'Match not found.'
      redirect_back(fallback_location: team_dashboard_path)
    end
  end

  def contact_support
    # Implement contact support functionality here
    # Example: Render a contact form or send an email to support
  end

  private

  # Ensure that only users with the "Team" role can access the dashboard
  def ensure_team_user
    unless current_user&.team?
      flash[:alert] = 'Access denied! Please create a team to access the dashboard.'
      redirect_to new_team_path # Redirect to team creation page to prevent infinite loop
    end
  end

  # Set the @team instance variable based on the current user's team association
  def set_team
    @team = current_user.team
  end

  # Load team-specific data to DRY up controller actions
  def load_team_data
    @players = @team.players
    @upcoming_matches = @team.upcoming_matches
    @past_matches = @team.past_matches
    @team_logo = @team.logo
  end

  # Strong parameters for updating team data
  def team_params
    params.require(:team).permit(:name, :logo, :contact_email, :contact_phone, :description)
  end
end