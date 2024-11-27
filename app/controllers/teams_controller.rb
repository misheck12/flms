class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_role
  before_action :set_league
  before_action :set_team, only: [:edit, :update]
  before_action :redirect_if_team_exists, only: [:new, :create], unless: :team_absent?
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

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    @team.user = current_user

    if @team.save
      redirect_to team_dashboard_path, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # GET /teams/:id/edit
  def edit
    # @team is set by set_team
  end

  # PATCH/PUT /teams/:id
  def update
    if @team.update(team_params)
      redirect_to team_dashboard_path, notice: 'Team was successfully updated.'
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

  def ensure_team_role
    redirect_to root_path, alert: 'Unauthorized access.' unless current_user.team?
  end

  def set_team
    @team = current_user.team
    redirect_to new_team_path, alert: 'Please create a team first.' if @team.nil?
  end

  def redirect_if_team_exists
    if current_user.team.present?
      redirect_to edit_team_path(current_user.team), notice: 'You already have a team.'
    end
  end

  def team_absent?
    current_user.team.nil?
  end

  # Strong parameters to whitelist team attributes
  def team_params
    params.require(:team).permit(
      :name, :city, :stadium, :foundation_year,
      :president, :manager, :league_id
    )
  end
end
