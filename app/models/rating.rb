class Rating < ApplicationRecord
  has_many :technical_coach_ratings
  has_many :technical_coaches, through: :technical_coach_ratings
  validates :landing_id, uniqueness: true
end
