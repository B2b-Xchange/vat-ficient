# coding: utf-8
class Address < ApplicationRecord
  belongs_to :order

  validates :company, presence: true, if: :company_address?
  validates :first_name, presence: true, if: :person_address?
  validates :surname, presence: true, if: :person_address?  
  validates :street_name, presence: true, length: { maximum: 50 }
  validates :street_number, presence: true, length: { maximum: 7 }
  validates :post_code, presence: true, length: { maximum: 8 }
  validates :city, presence: true, length: { maximum: 50 }
  
  validate :is_valid_birthday?


  private
  def is_valid_birthday?
    if ((:birthday.is_a?(Date) rescue ArgumentError) == ArgumentError)
      errors.add(:birthday, 'Ungültiges Geburtsdatum angegeben')
    end
  end

  def company_address?
    self.kind == 1
  end

  def person_address?
    self.kind == 2
  end
  
end
