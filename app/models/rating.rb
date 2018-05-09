class Rating < ApplicationRecord
  has_many :technical_coach_ratings
  has_many :technical_coaches, through: :technical_coach_ratings
  validates :landing_id, uniqueness: true

  def self.star_percent(star)
    result = where("stars = ?", star).count.to_f * (100.to_f/count.to_f)
    result.round
  end

  def self.star_count(star)
    where("stars = ?", star).count
  end
end
