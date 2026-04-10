class Equipment < ApplicationRecord
<<<<<<< HEAD
	belongs_to :tenant
=======
  has_many :time_slots, as: :bookable
>>>>>>> origin/booking
end
