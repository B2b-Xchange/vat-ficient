class Order < ApplicationRecord
  has_many :addresses
  has_many :order_lines

  validates :confirmation, acceptance: true
end
