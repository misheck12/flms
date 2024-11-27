class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_team_exists, only: [:new, :create]
  before_action :ensure_team_role, only: [:show, :edit, :update, :destroy]
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /leagues/:league_id/teams
  def index
    @q = policy_scope(@league.teams).ransack(params[:q])
    @teams = @q.result.includes(:league).alphabetical.page(params[:page]).per(10)
  end

  # GET /teams/:id
  def show
    # Display team details
    # This action can be removed if not needed
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = current_user.build_team(team_params)
    if @team.save
      redirect_to team_dashboard_path, notice: 'Team created successfully!'
    else
      flash.now[:alert] = 'Failed to create team.'
      render :new
    end
  end

  # GET /teams/:id/edit
  def edit
    # Render edit team form
  end

  # PATCH/PUT /teams/:id
  def update
    if @team.update(team_params)
      redirect_to team_dashboard_path, notice: 'Team updated successfully!'
    else
      flash.now[:alert] = 'Failed to update team.'
      render :edit
    end
  end

  # DELETE /teams/:id
  def destroy
    @team.destroy
    redirect_to root_path, notice: 'Team was successfully deleted.'
  end

  private

  # Redirect users who already have a team to their dashboard
  def redirect_if_team_exists
    if current_user.team.present?
      redirect_to team_dashboard_path, notice: 'You already have a team.'
    end
  end

  # Ensure that only users with the "Team" role can access certain actions
  def ensure_team_role
    unless current_user.team?
      redirect_to root_path, alert: 'Unauthorized access.'
    end
  end

  # Set the @team instance variable based on the current user's team
  def set_team
    @team = current_user.team
    unless @team
      redirect_to new_team_path, alert: 'Please create a team first.'
    end
  end

  # Strong parameters for team
  def team_params
    params.require(:team).permit(:name, :logo, :contact_email, :contact_phone, :description)
  end
end
