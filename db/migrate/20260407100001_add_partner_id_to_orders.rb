class AddPartnerIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :partner_id, :integer
    add_index :orders, :partner_id
  end
end
