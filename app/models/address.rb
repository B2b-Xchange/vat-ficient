# coding: utf-8
class Address < ApplicationRecord
  belongs_to :order

  validates :street_name, presence: true
  validates :street_number, presence: true
  validates :post_code, presence: true
  validates :city, presence: true
  validates :is_valid_birthday?


  private
  def is_valid_birthday?
    if ((:birthday.is_a?(Date) rescue ArgumentError) == ArgumentError)
      errors.add(:birthday, 'Ungültiges Geurtsdatum angegeben')
  end
  
end
