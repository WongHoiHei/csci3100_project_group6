class AddLocationIdToVenues < ActiveRecord::Migration[8.1]
  def change
    add_reference :venues, :location, foreign_key: true
  end
end
