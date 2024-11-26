class Team < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :league
  has_many :team_histories, dependent: :destroy
  has_many :players, dependent: :nullify
  has_many :matches_home, class_name: 'Match', foreign_key: 'home_team_id', dependent: :nullify
  has_many :matches_away, class_name: 'Match', foreign_key: 'away_team_id', dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: { scope: :league_id, message: "must be unique within the league" }, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :stadium, presence: true, length: { maximum: 150 }
  validates :foundation_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1800, less_than_or_equal_to: Date.current.year }
  validates :president, presence: true, length: { maximum: 100 }
  validates :manager, presence: true, length: { maximum: 100 }

  # Callbacks
  before_validation :capitalize_attributes

  # Scopes
  scope :alphabetical, -> { order(name: :asc) }
  scope :recent_foundations, -> { where('foundation_year >= ?', Date.current.year - 50) }
  scope :by_league, ->(league_id) { where(league_id: league_id) }

  # Methods

  # Total points from all team histories
  def total_points
    team_histories.sum(:points)
  end

  # Average position in the league across all seasons
  def average_position
    team_histories.average(:position_in_league).to_f.round(2)
  end

  # Retrieve the most successful season (highest points)
  def most_successful_season
    team_histories.order(points: :desc).first
  end

  # Retrieve the least successful season (lowest points)
  def least_successful_season
    team_histories.order(points: :asc).first
  end

  private

  # Capitalize specific attributes for consistency
  def capitalize_attributes
    self.name = name.capitalize if name.present?
    self.city = city.capitalize if city.present?
    self.stadium = stadium.split.map(&:capitalize).join(' ') if stadium.present?
    self.president = president.split.map(&:capitalize).join(' ') if president.present?
    self.manager = manager.split.map(&:capitalize).join(' ') if manager.present?
  end
end
