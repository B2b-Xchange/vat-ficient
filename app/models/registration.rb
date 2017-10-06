
# has no table, only for form builder
class Registration
  include ActiveModel::Model

  attr_accessor :registration_germany, :registration_poland, :registration_czech,
                :registration_austria, :registration_spain, :registration_france,
                :registration_uk, :registration_italy, :registration_other
  
end
