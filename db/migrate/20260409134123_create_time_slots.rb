class CreateTimeSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :time_slots do |t|
      t.references :venue, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
