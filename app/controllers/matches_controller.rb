class MatchesController < ApplicationController
  before_action :set_league
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /leagues/:league_id/matches
  def index
    @matches = @league.matches.includes(:home_team, :away_team).order(:date)
  end

  # GET /leagues/:league_id/matches/:id
  def show
    @match_report = @match.match_reports.first
  end

  # GET /leagues/:league_id/matches/new
  def new
    @match = @league.matches.build
  end

  # POST /leagues/:league_id/matches
  def create
    @match = @league.matches.build(match_params)
    if @match.save
      redirect_to league_match_path(@league, @match), notice: 'Match was successfully created.'
    else
      render :new
    end
  end

  # GET /leagues/:league_id/matches/:id/edit
  def edit
  end

  # PATCH/PUT /leagues/:league_id/matches/:id
  def update
    if @match.update(match_params)
      redirect_to league_match_path(@league, @match), notice: 'Match was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leagues/:league_id/matches/:id
  def destroy
    @match.destroy
    redirect_to league_matches_path(@league), notice: 'Match was successfully destroyed.'
  end

  private

  # Sets the current league based on the league_id parameter
  def set_league
    @league = League.find(params[:league_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to leagues_path, alert: 'League not found.'
  end

  # Sets the current match based on the id parameter within the league
  def set_match
    @match = @league.matches.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to league_matches_path(@league), alert: 'Match not found.'
  end

  # Strong parameters to whitelist match attributes
  def match_params
    params.require(:match).permit(:date, :venue, :home_team_id, :away_team_id)
  end
end
