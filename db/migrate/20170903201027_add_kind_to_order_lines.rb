class AddKindToOrderLines < ActiveRecord::Migration[5.1]
  def change
    add_column :order_lines, :kind, :integer
  end
end
