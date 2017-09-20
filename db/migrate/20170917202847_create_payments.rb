class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :payment_type
      t.integer :kind
      t.integer :status
      t.string :transaction_reference

      t.timestamps
    end
  end
end
