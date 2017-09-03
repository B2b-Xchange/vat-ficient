class CreateOrderLines < ActiveRecord::Migration[5.1]
  def change
    create_table :order_lines do |t|
      t.references :order, foreign_key: true
      t.integer :type
      t.string :country_iso_code
    end
  end
end
