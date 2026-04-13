class RemoveVenueIdFromTimeSlots < ActiveRecord::Migration[8.1]
  def change
    remove_column :time_slots, :venue_id, :integer
  end
end
