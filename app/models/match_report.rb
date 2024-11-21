class MatchReport < ApplicationRecord
  belongs_to :match
  belongs_to :referee

  # Attributes:
  # t.integer :home_team_goals, default: 0
  # t.integer :away_team_goals, default: 0
  # t.text :report_details, null: false
  # t.text :notable_incidents

  # Validations
  validates :home_team_goals, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :away_team_goals, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :report_details, presence: true

  # Associations
  has_many :goals, dependent: :destroy
  has_many :cards, dependent: :destroy

  accepts_nested_attributes_for :goals, allow_destroy: true
  accepts_nested_attributes_for :cards, allow_destroy: true

  # Methods

  # Calculate total goals in the match
  def total_goals
    home_team_goals + away_team_goals
  end

  # Determine the result of the match
  def match_result
    if home_team_goals > away_team_goals
      :home_win
    elsif home_team_goals < away_team_goals
      :away_win
    else
      :draw
    end
  end

  # Update league standings after saving the match report
  after_save :update_league_standings

  private

  def update_league_standings
    LeagueStanding.update_after_match(match)
  end
end
