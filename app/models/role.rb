class Role < ApplicationRecord
    belongs_to :user, required: false
end
