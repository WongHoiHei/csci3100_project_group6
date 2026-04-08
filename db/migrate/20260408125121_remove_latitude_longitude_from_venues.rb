class RemoveLatitudeLongitudeFromVenues < ActiveRecord::Migration[8.1]
  def change
    remove_column :venues, :latitude, :float
    remove_column :venues, :longitude, :float
  end
end
