class Player < ApplicationRecord
  # Associations
  belongs_to :team

  has_many :goals, dependent: :nullify
  has_many :assists, class_name: 'Goal', foreign_key: 'assist_player_id', dependent: :nullify
  has_many :cards, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: { scope: :team_id, message: "must be unique within the team" }
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 },
                     uniqueness: { scope: :team_id, message: "must be unique within the team" }
  validates :position, presence: true, inclusion: { in: positions.keys }

  # Enums for player positions
  enum position: { goalkeeper: "Goalkeeper", defender: "Defender", midfielder: "Midfielder", forward: "Forward" }

  # Callbacks (optional)
  before_validation :assign_default_position, if: -> { position.blank? }

  # Methods

  # Total goals scored by the player
  def total_goals
    goals.count
  end

  # Total assists made by the player
  def total_assists
    assists.count
  end

  # Total yellow cards received by the player
  def yellow_cards
    cards.where(card_type: 'yellow').count
  end

  # Total red cards received by the player
  def red_cards
    cards.where(card_type: 'red').count
  end

  # Total disciplinary points (e.g., yellow = 1, red = 2)
  def disciplinary_points
    (yellow_cards * 1) + (red_cards * 2)
  end

  # Total matches played (assuming each goal, assist, or card implies participation)
  def matches_played
    Match.joins(:match_reports)
         .where(match_reports: { id: goals.select(:match_report_id).union(assists.select(:match_report_id)).union(cards.select(:match_report_id)) })
         .distinct
         .count
  end

  private

  # Assign a default position if none is provided
  def assign_default_position
    self.position ||= "Midfielder"
  end
end
