class LeagueStandingsController < ApplicationController
  before_action :set_league
  before_action :set_standing, only: [:show, :edit, :update, :destroy]

  # GET /leagues/:league_id/league_standings
  def index
    @standings = @league.league_standings.ordered_standings
  end

  # GET /leagues/:league_id/league_standings/1
  def show
  end

  # GET /leagues/:league_id/league_standings/new
  def new
    @standing = @league.league_standings.new
  end

  # POST /leagues/:league_id/league_standings
  def create
    @standing = @league.league_standings.new(standing_params)
    if @standing.save
      redirect_to [@league, @standing], notice: 'Standing was successfully created.'
    else
      render :new
    end
  end

  # GET /leagues/:league_id/league_standings/1/edit
  def edit
  end

  # PATCH/PUT /leagues/:league_id/league_standings/1
  def update
    if @standing.update(standing_params)
      redirect_to [@league, @standing], notice: 'Standing was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leagues/:league_id/league_standings/1
  def destroy
    @standing.destroy
    redirect_to league_league_standings_path(@league), notice: 'Standing was successfully destroyed.'
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

  def set_standing
    @standing = @league.league_standings.find(params[:id])
  end

  def standing_params
    params.require(:league_standing).permit(
      :team_id,
      :wins,
      :draws,
      :losses,
      :goals_scored,
      :goals_conceded,
      :disciplinary_points
    )
  end
end
