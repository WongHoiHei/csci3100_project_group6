class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :location
      t.integer :capacity
      t.float :latitude
      t.float :longitude
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
