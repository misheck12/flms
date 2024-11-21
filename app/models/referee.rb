class Referee < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :match_reports, dependent: :nullify

  # Validations
  validates :certification_level, presence: true, inclusion: { in: certification_levels.keys }
  validates :experience_years, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bio, length: { maximum: 1000 }, allow_blank: true

  # Enums for certification levels
  enum certification_level: { local: "Local", regional: "Regional", national: "National", international: "International" }

  # Callbacks
  before_validation :set_default_certification_level, if: -> { certification_level.blank? }

  # Methods

  # Total matches officiated by the referee
  def total_matches_officiated
    match_reports.count
  end

  # Average goals per match officiated
  def average_goals_per_match
    total_goals = match_reports.joins(:match).sum('matches.home_team_goals + matches.away_team_goals')
    total_matches = total_matches_officiated
    return 0 if total_matches.zero?

    (total_goals.to_f / total_matches).round(2)
  end

  # Retrieve the most recent match officiated
  def recent_match
    match_reports.order(created_at: :desc).first&.match
  end

  private

  # Assign a default certification level if none is provided
  def set_default_certification_level
    self.certification_level ||= "local"
  end
end
