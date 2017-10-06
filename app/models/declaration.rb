
# has no table, only for form builder
class Declaration
  include ActiveModel::Model

  attr_accessor :declaration_germany, :declaration_poland, :declaration_czech,
                :declaration_austria, :declaration_spain, :declaration_france,
                :declaration_uk, :declaration_italy, :declaration_other
  
end
