class Equipment < ApplicationRecord
  has_many :time_slots, as: :bookable, dependent: :destroy
end
