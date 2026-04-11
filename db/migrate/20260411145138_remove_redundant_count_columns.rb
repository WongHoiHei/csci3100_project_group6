class RemoveRedundantCountColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :venues, :booking_count, :integer, default: 0, null: false
    
    remove_column :equipment, :usage_count, :integer, default: 0, null: false
  end
end