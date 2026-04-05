class Tenant < ApplicationRecord
    has_many :users
    has_many :venues
    has_many :equipments
end
