class LeagueStanding < ApplicationRecord
  belongs_to :league
  belongs_to :team

  # Attributes:
  # t.integer :points, default: 0
  # t.integer :wins, default: 0
  # t.integer :draws, default: 0
  # t.integer :losses, default: 0
  # t.integer :goals_scored, default: 0
  # t.integer :goals_conceded, default: 0
  # t.integer :goal_difference, default: 0
  # t.integer :disciplinary_points, default: 0

  # Validations
  validates :points, :wins, :draws, :losses, :goals_scored, :goals_conceded,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Callbacks
  before_save :calculate_goal_difference

  # Scope to order standings based on tie-breaker rules
  scope :ordered_standings, -> {
    left_outer_joins(:team)
      .select('league_standings.*, teams.name AS team_name')
      .order(
        points: :desc,
        goal_difference: :desc,
        goals_scored: :desc,
        'teams.name ASC'
      )
  }

  # Method to update standings after a match
  def self.update_after_match(match)
    league = match.league
    home_team_standing = league.league_standings.find_or_create_by(team: match.home_team)
    away_team_standing = league.league_standings.find_or_create_by(team: match.away_team)

    # Update goals scored and conceded
    home_team_standing.goals_scored += match.home_team_score
    home_team_standing.goals_conceded += match.away_team_score
    away_team_standing.goals_scored += match.away_team_score
    away_team_standing.goals_conceded += match.home_team_score

    # Update wins, draws, losses, and points
    if match.home_team_score > match.away_team_score
      home_team_standing.wins += 1
      away_team_standing.losses += 1
    elsif match.home_team_score < match.away_team_score
      away_team_standing.wins += 1
      home_team_standing.losses += 1
    else
      home_team_standing.draws += 1
      away_team_standing.draws += 1
    end

    # Recalculate points
    home_team_standing.calculate_points
    away_team_standing.calculate_points

    # Save the updated standings
    home_team_standing.save
    away_team_standing.save
  end

  # Calculate points based on wins and draws
  def calculate_points
    self.points = (wins * 3) + draws
  end

  def self.update_after_match(match)
    # Fetch or create standings for both teams
    home_standing = find_or_create_by(league: match.league, team: match.home_team)
    away_standing = find_or_create_by(league: match.league, team: match.away_team)

    # Update goals scored and conceded
    home_standing.goals_scored += match_report.home_team_goals
    home_standing.goals_conceded += match_report.away_team_goals
    away_standing.goals_scored += match_report.away_team_goals
    away_standing.goals_conceded += match_report.home_team_goals

    # Update wins, draws, losses, and points based on match result
    case match_report.match_result
    when :home_win
      home_standing.wins += 1
      away_standing.losses += 1
    when :away_win
      away_standing.wins += 1
      home_standing.losses += 1
    when :draw
      home_standing.draws += 1
      away_standing.draws += 1
    end

    # Save the updated standings
    home_standing.save
    away_standing.save
  end

  private

  # Calculate goal difference
  def calculate_goal_difference
    self.goal_difference = goals_scored - goals_conceded
  end
end
