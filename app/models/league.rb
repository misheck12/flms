class League < ApplicationRecord
  # Add the new attributes
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  # Add any necessary associations
  has_many :teams
  has_many :matches
end
