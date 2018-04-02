class Admin < ApplicationRecord
    has_one :role, required: true
end
