class Admin < ApplicationRecord
    has_one :role, required: true
    delegate :user, to: :role
end
