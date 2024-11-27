class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    case current_user.role
    when 'admin'
      load_admin_dashboard
    when 'referee'
      load_referee_dashboard
    when 'team'
      load_team_dashboard
    else
      redirect_to root_path, alert: "Unauthorized access."
    end
  end

  private

  # Load Admin Dashboard Data
  def load_admin_dashboard
    @leagues = League.all.order(created_at: :desc)
    @total_teams = Team.count
    @total_referees = Referee.count
    @recent_matches = Match.order(match_date: :desc).limit(5)
    @pending_reports = MatchReport.where(report_details: nil).count
  end

  # Load Referee Dashboard Data
  def load_referee_dashboard
    @assigned_matches = current_user.referee.matches.where("match_date >= ?", Date.today).order(:match_date)
    @recent_reports = MatchReport.where(referee: current_user.referee).order(created_at: :desc).limit(5)
    @unclaimed_matches = Match.where(referee_id: nil).where("match_date >= ?", Date.today).order(:match_date)
  end

  # Load Team Dashboard Data
  def load_team_dashboard
    @team = current_user.team
    @upcoming_matches = @team.matches.where("match_date >= ?", Date.today).order(:match_date)
    @recent_matches = @team.matches.where("match_date < ?", Date.today).order(match_date: :desc).limit(5)
    @players = @team.players.order(:name)
  end
end
