class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :number
      t.string :email
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
