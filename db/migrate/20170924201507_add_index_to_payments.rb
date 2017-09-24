class AddIndexToPayments < ActiveRecord::Migration[5.1]
  def change
    add_index :payments, :transaction_reference
  end
end
