class RemoveTenantIdFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :tenant_id, :integer
  end
end
