class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :company
      t.string :first_name
      t.string :surname
      t.string :street_name
      t.string :street_number
      t.string :post_code
      t.string :city
      t.string :country
      t.string :tax_no
      t.datetime :birthday
    end
  end
end
