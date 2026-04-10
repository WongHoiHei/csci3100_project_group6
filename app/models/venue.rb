class Venue < ApplicationRecord
  
  belongs_to :location
  has_many :time_slots, as: :bookable, dependent: :destroy
end
