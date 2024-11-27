class TeamDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_user
  before_action :set_team

  def index
    if @team.present?
      load_team_data
    else
      flash[:alert] = 'No team data found. Please complete your team setup.'
      redirect_to edit_team_info_path # Redirect to team setup
    end
  end

  def show
    if @team.present?
      load_team_data
      # Check if the team has players
      if @players.empty?
        flash[:notice] = 'Your team has no players yet. Add players to your team.'
        # Assuming you have a new_player_path or similar to add players
        redirect_to new_player_path 
      end
      # Check if the team has upcoming matches
      if @upcoming_matches.empty?
        flash[:notice] = 'Your team has no upcoming matches scheduled.'
        # Assuming you have a new_match_path or similar to schedule matches
        redirect_to new_match_path 
      end
      # Check if the team has past matches
      if @past_matches.empty?
        flash[:notice] = 'Your team has not played any matches yet.'
        # Potentially redirect to a page to schedule matches or view past results
        redirect_to matches_path 
      end
    else
      flash[:notice] = 'You haven\'t created a team yet. Please create one to get started.'
      redirect_to new_team_path 
    end
  end

  # Since index and show have the same logic, you can remove the show action

  def edit_team_info
    # No need for a conditional here since set_team will handle it
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
    @league = League.find(params[:league_id]) # Use find instead of find_by for simpler error handling
    if @league
      @standings = @league.standings
    else
      redirect_to team_dashboard_path, alert: 'League not found.' # Redirect with alert
    end
  end

  def view_match_report
    @match = Match.find(params[:match_id]) # Use find instead of find_by
    if @match
      @report = @match.match_report
    else
      redirect_to team_dashboard_path, alert: 'Match not found.' # Redirect with alert
    end
  end

  def contact_support
    # Implement contact support functionality here
  end

  private

  def ensure_team_user
    unless current_user&.team?
      flash[:alert] = 'Access denied! Only team accounts can view this dashboard.'
      redirect_to root_path # Redirect to root if not a team user
    end
  end

  def set_team
    @team = current_user.team
    if @team.nil?
      flash[:alert] = 'No associated team found. Please create a team first.'
      redirect_to edit_team_info_path # Redirect to team setup
    end
  end

  def load_team_data
    @players = @team.players
    @upcoming_matches = @team.upcoming_matches
    @past_matches = @team.past_matches
    @team_logo = @team.logo
  end

  def team_params
    params.require(:team).permit(:name, :logo, :contact_email, :contact_phone, :description)
  end
end