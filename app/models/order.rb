# coding: utf-8
class Order < ApplicationRecord
  has_many :addresses
  has_many :order_lines
  has_many :payments
  validates_associated :addresses

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :confirmation, acceptance: true
  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  validates :value, numericality: { greater_than: 0 }
  
end
