class Match < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  validates :date, :venue, :home_team_id, :away_team_id, presence: true
  validate :teams_must_be_different

  private

  def teams_must_be_different
    if home_team_id == away_team_id
      errors.add(:away_team_id, "can't be the same as home team")
    end
  end
end