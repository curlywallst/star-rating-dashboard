class Role < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :admin, required: false
end
