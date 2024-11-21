class TeamHistory < ApplicationRecord
  # Associations
  belongs_to :team

  # Validations
  validates :season_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900 }
  validates :position_in_league, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :wins, :draws, :losses, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :goals_for, :goals_against, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :calculate_points

  # Methods

  # Calculates total points based on wins and draws
  def calculate_points
    self.points = (wins * 3) + draws
  end
end
