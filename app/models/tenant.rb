class Tenant < ApplicationRecord
    has_many :users
    has_many :equipments
end
