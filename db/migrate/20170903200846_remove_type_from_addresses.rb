class RemoveTypeFromAddresses < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :type, :integer
  end
end
