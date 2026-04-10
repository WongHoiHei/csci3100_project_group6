class AddNumberOfPastBookingToVenuesAndEquipment < ActiveRecord::Migration[8.0]
  def up
    add_column :venues, :number_of_past_booking, :integer, null: false, default: 0
    add_column :equipment, :number_of_past_booking, :integer, null: false, default: 0

    execute <<~SQL
      CREATE TRIGGER increment_number_of_past_booking_after_booking_insert
      AFTER INSERT ON bookings
      BEGIN
        UPDATE equipment
        SET number_of_past_booking = COALESCE(number_of_past_booking, 0) + 1
        WHERE id = NEW.bookable_id
          AND NEW.bookable_type = 'Equipment';

        UPDATE venues
        SET number_of_past_booking = COALESCE(number_of_past_booking, 0) + 1
        WHERE id = NEW.bookable_id
          AND NEW.bookable_type = 'Venue';
      END;
    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS increment_number_of_past_booking_after_booking_insert;
    SQL

    remove_column :equipment, :number_of_past_booking
    remove_column :venues, :number_of_past_booking
  end
end
