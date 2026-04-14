class Venue < ApplicationRecord
  belongs_to :location
  has_many :bookings, as: :bookable, dependent: :destroy
end
