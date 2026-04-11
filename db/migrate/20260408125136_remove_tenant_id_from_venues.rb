class RemoveTenantIdFromVenues < ActiveRecord::Migration[8.1]
  def change
    remove_column :venues, :tenant_id, :integer
  end
end
