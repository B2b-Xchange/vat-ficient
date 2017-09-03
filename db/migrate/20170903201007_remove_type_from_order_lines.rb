class RemoveTypeFromOrderLines < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_lines, :type, :integer
  end
end
