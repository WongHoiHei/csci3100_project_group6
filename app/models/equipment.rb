class Equipment < ApplicationRecord
  belongs_to :tenant
  has_many :time_slots, as: :bookable
end
