class TeamHistoriesController < ApplicationController
  before_action :set_team
  before_action :set_team_history, only: [:show, :edit, :update, :destroy]

  # GET /teams/:team_id/team_histories
  def index
    @team_histories = @team.team_histories.order(season_year: :desc)
  end

  # GET /teams/:team_id/team_histories/1
  def show
  end

  # GET /teams/:team_id/team_histories/new
  def new
    @team_history = @team.team_histories.build
  end

  # POST /teams/:team_id/team_histories
  def create
    @team_history = @team.team_histories.build(team_history_params)
    if @team_history.save
      redirect_to [@team, @team_history], notice: 'Team history was successfully created.'
    else
      render :new
    end
  end

  # GET /teams/:team_id/team_histories/1/edit
  def edit
  end

  # PATCH/PUT /teams/:team_id/team_histories/1
  def update
    if @team_history.update(team_history_params)
      redirect_to [@team, @team_history], notice: 'Team history was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/:team_id/team_histories/1
  def destroy
    @team_history.destroy
    redirect_to team_team_histories_path(@team), notice: 'Team history was successfully destroyed.'
  end

  private

  # Sets the current team based on the team_id parameter
  def set_team
    @team = Team.find(params[:team_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to teams_path, alert: 'Team not found.'
  end

  # Sets the current team history based on the id parameter within the team
  def set_team_history
    @team_history = @team.team_histories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to team_team_histories_path(@team), alert: 'Team history not found.'
  end

  # Strong parameters to whitelist team history attributes
  def team_history_params
    params.require(:team_history).permit(:season_year, :position_in_league, :wins, :draws, :losses, :goals_for, :goals_against)
  end
end
