class Match < ApplicationRecord
  belongs_to :league
  belongs_to :home_team
  belongs_to :away_team
end
