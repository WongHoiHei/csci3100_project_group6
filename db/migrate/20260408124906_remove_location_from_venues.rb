class RemoveLocationFromVenues < ActiveRecord::Migration[8.1]
  def change
    remove_column :venues, :location, :string
  end
end
