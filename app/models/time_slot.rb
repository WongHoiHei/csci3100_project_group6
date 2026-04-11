class TimeSlot < ApplicationRecord
  belongs_to :venue
  has_many :bookings
end
