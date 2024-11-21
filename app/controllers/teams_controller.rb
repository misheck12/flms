class TeamsController < ApplicationController
  before_action :set_league
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  # GET /leagues/:league_id/teams
  def index
    @q = policy_scope(@league.teams).ransack(params[:q])
    @teams = @q.result.includes(:league).alphabetical.page(params[:page]).per(10)
  end

  # GET /leagues/:league_id/teams/:id
  def show
    authorize @team
    @recent_team_histories = @team.team_histories.order(season_year: :desc).limit(5)
  end

  # GET /leagues/:league_id/teams/new
  def new
    @team = @league.teams.build
    authorize @team
  end

  # POST /leagues/:league_id/teams
  def create
    @team = @league.teams.build(team_params)
    authorize @team
    if @team.save
      redirect_to [@league, @team], notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # GET /leagues/:league_id/teams/:id/edit
  def edit
    authorize @team
  end

  # PATCH/PUT /leagues/:league_id/teams/:id
  def update
    authorize @team
    if @team.update(team_params)
      redirect_to [@league, @team], notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leagues/:league_id/teams/:id
  def destroy
    authorize @team
    @team.destroy
    redirect_to league_teams_path(@league), notice: 'Team was successfully destroyed.'
  end

  private

  # Sets the current league based on the league_id parameter
  def set_league
    @league = League.find(params[:league_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to leagues_path, alert: 'League not found.'
  end

  # Sets the current team based on the id parameter within the league
  def set_team
    @team = @league.teams.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to league_teams_path(@league), alert: 'Team not found.'
  end

  # Strong parameters to whitelist team attributes
  def team_params
    params.require(:team).permit(:name, :city, :stadium, :foundation_year, :president, :manager)
  end
end
