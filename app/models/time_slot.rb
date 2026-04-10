class TimeSlot < ApplicationRecord
  belongs_to :bookable, polymorphic: true
  has_many :bookings  
end
