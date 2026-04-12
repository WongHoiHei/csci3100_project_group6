class RemoveTenantIdFromEquipment < ActiveRecord::Migration[8.1]
  def change
    remove_column :equipment, :tenant_id, :integer
  end
end
