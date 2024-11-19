class MatchReport < ApplicationRecord
  belongs_to :match
  belongs_to :referee
end
