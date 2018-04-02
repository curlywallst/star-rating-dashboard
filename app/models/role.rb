class Role < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :admin, required: false
    belongs_to :technical_coach, required: false
end
