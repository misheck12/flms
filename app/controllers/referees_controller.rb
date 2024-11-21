class RefereesController < ApplicationController
  before_action :set_referee, only: [:show, :edit, :update, :destroy]

  # GET /referees
  def index
    @referees = Referee.includes(:user).order(:certification_level, :experience_years)
  end

  # GET /referees/1
  def show
  end

  # GET /referees/new
  def new
    @referee = Referee.new
  end

  # POST /referees
  def create
    @referee = Referee.new(referee_params)
    if @referee.save
      redirect_to @referee, notice: 'Referee was successfully created.'
    else
      render :new
    end
  end

  # GET /referees/1/edit
  def edit
  end

  # PATCH/PUT /referees/1
  def update
    if @referee.update(referee_params)
      redirect_to @referee, notice: 'Referee was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /referees/1
  def destroy
    @referee.destroy
    redirect_to referees_url, notice: 'Referee was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_referee
    @referee = Referee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to referees_url, alert: 'Referee not found.'
  end

  # Only allow a list of trusted parameters through.
  def referee_params
    params.require(:referee).permit(:user_id, :certification_level, :experience_years, :bio)
  end
end
