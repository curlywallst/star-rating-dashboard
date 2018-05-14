class Rating < ApplicationRecord
  has_many :technical_coach_ratings
  has_many :technical_coaches, through: :technical_coach_ratings
  validates :landing_id, uniqueness: true

  def self.star_percent(star)
    result = filter_by_star(star).count.to_f * (100.to_f/count.to_f)
    result.nan? ? 0 : result.round
  end

  def self.star_count(star)
    filter_by_star(star).count
  end

  def self.filter_by_star(star)
    where("stars = ?", star).order(date: :desc)
  end

  def parse_date
    self.date.strftime("%D")
  end
end
