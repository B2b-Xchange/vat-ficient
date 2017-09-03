class OrdersController < ApplicationController
  require 'securerandom'
  
  def new
    
  end

  def create
   
    @order = Order.new(order_params)
    @order.number = SecureRandom.uuid
    @company_address = @order.addresses.build(address_params[:company_address])
    @company_address.kind = 1
    @person_address = @order.addresses.build(address_params[:person_address])
    @person_address.kind = 2

    @order.save

    if order_line_params[:registration_germany] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "DE"})
    end

    if order_line_params[:registration_poland] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "PL"})
    end

    if order_line_params[:registration_czech] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "CZ"})
    end

    if order_line_params[:registration_austria] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "AT"})
    end

    if order_line_params[:registration_spain] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "ES"})
    end

    if order_line_params[:registration_france] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "FR"})
    end

    if order_line_params[:registration_uk] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "UK"})
    end

    if order_line_params[:registration_italy] == "1"
      @order.order_lines.create({kind: 1, country_iso_code: "IT"})
    end

    if order_line_params[:registration_other] == "1"
      @order.order_lines.create({kind: 1})
    end

    if order_line_params[:declaration_germany] == "1"
      @order.order_lines.create({kind: 2, country_iso_code: "DE"})
    end

    
                                  
    #dubug
    render plain: params[:order].inspect
  end

  private
  def order_params
    params.require(:order).permit(:email, :confirmation)
  end

  def address_params
    params.require(:order).permit(company_address: [:company, :first_name, :surname, :street_name,
                                                    :street_number, :post_code, :city, :country,
                                                    :tax_no],
                                  person_address: [:first_name, :surname, :street_name, :street_number,
                                                   :post_code, :city, :country, :birthday])
  end

  def order_line_params
    params.require(:order).permit(:registration_germany, :registration_poland,
                                  :registration_czech, :registration_austria,
                                  :registration_spain, :registration_france, :registration_uk,
                                  :registration_italy, :registration_other, :declaration_germany,
                                  :declaration_poland, :declaration_czech, :declaration_austria,
                                  :declaration_spain, :declaration_france, :declaration_uk,
                                  :declaration_italy, :declaration_other)
  end
end
