class TechnicalCoach < ApplicationRecord
    has_one :role
    has_many :technical_coach_ratings
    has_many :ratings, through: :technical_coach_ratings
    validates :name, presence: true, uniqueness: true

    def study_group_ratings
      self.ratings.where("rating_type = ?", "SG")
    end

    def aaq_ratings
      self.ratings.where("rating_type = ?", "AAQ")
    end

end
