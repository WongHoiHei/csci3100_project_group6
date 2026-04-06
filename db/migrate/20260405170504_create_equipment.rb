class CreateEquipment < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment do |t|
      t.string :name
      t.text :description
      t.integer :total_count
      t.integer :available_count
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
