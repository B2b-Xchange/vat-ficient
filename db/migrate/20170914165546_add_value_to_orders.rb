class AddValueToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :value, :integer
  end
end
