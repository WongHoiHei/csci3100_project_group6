class AddBookingCountToVenues < ActiveRecord::Migration[8.1]
  def change
    add_column :venues, :booking_count, :integer, default: 0, null: false
  end
end
