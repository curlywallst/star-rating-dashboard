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

    def get_aaq_ratings_by_month(month)
      if month != "All"
        self.aaq_ratings.where('extract(month from date) = ?', Date::MONTHNAMES.index(month))
      else
        self.aaq_ratings
      end
    end

    def get_study_group_ratings_by_month(month)
      if month != "All"
        self.study_group_ratings.where('extract(month from date) = ?', Date::MONTHNAMES.index(month))
      else
        self.study_group_ratings
      end
    end

    def self.get_aaq_coaches
      self.select{|tc| tc.aaq_ratings.find{|sg| sg.rating_type == "AAQ"}}
    end

    def self.get_study_group_coaches
      self.select{|tc| tc.study_group_ratings.find{|sg| sg.rating_type == "SG"}}
    end

    def slug
      self.name.downcase.split(" ").join("-")
    end

    def self.find_by_slug(slug)
      self.find{|tc| tc.slug == slug}
    end
end
