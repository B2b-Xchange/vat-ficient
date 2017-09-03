class AddKindToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :kind, :integer
  end
end
