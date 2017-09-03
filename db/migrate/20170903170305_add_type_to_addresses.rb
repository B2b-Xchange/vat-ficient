class AddTypeToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :type, :int
  end
end
