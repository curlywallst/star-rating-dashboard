class TechnicalCoach < ApplicationRecord
    has_one :role

    validates :name, presence: true, uniqueness: true
end
