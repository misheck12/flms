class MatchReportsController < ApplicationController
  # Before actions and other methods...

  def create
    @match_report = MatchReport.new(match_report_params)
    if @match_report.save
      redirect_to @match_report, notice: 'Match report was successfully created.'
    else
      render :new
    end
  end

  private

  def match_report_params
    params.require(:match_report).permit(
      :match_id,
      :referee_id,
      :home_team_goals,
      :away_team_goals,
      :report_details,
      :notable_incidents,
      goals_attributes: [:id, :player_id, :assist_player_id, :minute, :_destroy],
      cards_attributes: [:id, :player_id, :card_type, :minute, :_destroy]
    )
  end
end
