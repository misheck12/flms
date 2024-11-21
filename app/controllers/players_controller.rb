class PlayersController < ApplicationController
  before_action :set_league
  before_action :set_team
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /leagues/:league_id/teams/:team_id/players
  def index
    @players = @team.players.order(:number)
  end

  # GET /leagues/:league_id/teams/:team_id/players/:id
  def show
  end

  # GET /leagues/:league_id/teams/:team_id/players/new
  def new
    @player = @team.players.build
  end

  # POST /leagues/:league_id/teams/:team_id/players
  def create
    @player = @team.players.build(player_params)
    if @player.save
      redirect_to [@league, @team, @player], notice: 'Player was successfully created.'
    else
      render :new
    end
  end

  # GET /leagues/:league_id/teams/:team_id/players/:id/edit
  def edit
  end

  # PATCH/PUT /leagues/:league_id/teams/:team_id/players/:id
  def update
    if @player.update(player_params)
      redirect_to [@league, @team, @player], notice: 'Player was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leagues/:league_id/teams/:team_id/players/:id
  def destroy
    @player.destroy
    redirect_to league_team_players_path(@league, @team), notice: 'Player was successfully deleted.'
  end

  private

  # Sets the current league based on the league_id parameter
  def set_league
    @league = League.find(params[:league_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to leagues_path, alert: 'League not found.'
  end

  # Sets the current team based on the team_id parameter within the league
  def set_team
    @team = @league.teams.find(params[:team_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to league_teams_path(@league), alert: 'Team not found.'
  end

  # Sets the current player based on the id parameter within the team
  def set_player
    @player = @team.players.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to league_team_players_path(@league, @team), alert: 'Player not found.'
  end

  # Strong parameters to whitelist player attributes
  def player_params
    params.require(:player).permit(:name, :number, :position)
  end
end
