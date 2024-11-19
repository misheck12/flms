class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]

  # GET /leagues
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  def show
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to @league, notice: 'League was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /leagues/1
  def update
    if @league.update(league_params)
      redirect_to @league, notice: 'League was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leagues/1
  def destroy
    @league.destroy
    redirect_to leagues_url, notice: 'League was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_league
    @league = League.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def league_params
    params.require(:league).permit(:name, :description, :start_date, :end_date, :rules)
  end
end
