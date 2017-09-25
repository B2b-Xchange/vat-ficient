# coding: utf-8
class OrdersController < ApplicationController
  require 'securerandom'

  def index
  end

  def show
    @order = Order.find(params[:id])
    
  end
  
  def new
    @order = Order.new
    @company_address = Address.new
    @person_address = Address.new

  end

  def create
   
    @order = Order.new(order_params)
    @order.number = SecureRandom.uuid
    @company_address = @order.addresses.build(address_params[:company_address])
    @company_address.kind = 1
    @person_address = @order.addresses.build(address_params[:person_address])
    @person_address.kind = 2

    if order_line_params[:registrations][:registration_germany] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "DE"})
    end

    if order_line_params[:registrations][:registration_poland] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "PL"})
    end

    if order_line_params[:registrations][:registration_czech] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "CZ"})
    end

    if order_line_params[:registrations][:registration_austria] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "AT"})
    end

    if order_line_params[:registrations][:registration_spain] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "ES"})
    end

    if order_line_params[:registrations][:registration_france] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "FR"})
    end

    if order_line_params[:registrations][:registration_uk] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "UK"})
    end

    if order_line_params[:registrations][:registration_italy] == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "IT"})
    end

    if order_line_params[:registrations][:registration_other] == "1"
      @order.order_lines.build({kind: 1})
    end

    if order_line_params[:declarations][:declaration_germany] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "DE"})
    end

    if order_line_params[:declarations][:declaration_poland] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "PL"})
    end

    if order_line_params[:declarations][:declaration_czech] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "CZ"})
    end

    if order_line_params[:declarations][:declaration_austria] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "AT"})
    end

    if order_line_params[:declarations][:declaration_spain] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "ES"})
    end

    if order_line_params[:declarations][:declaration_france] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "FR"})
    end

    if order_line_params[:declarations][:declaration_uk] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "UK"})
    end

    if order_line_params[:declarations][:declaration_italy] == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "IT"})
    end

    if order_line_params[:declarations][:declaration_other] == "1"
      @order.order_lines.build({kind: 2})
    end

    # calculate order value and save to @order
    number_registration = 0
    number_declaration = 0
    price = 0
    @order.order_lines.each do |line|
      if line.kind == 1
        number_registration += 1
      end

      if line.kind == 2
        number_declaration += 1
      end
    end

    if number_registration < 3
      price += 420
    elsif number_registration < 5
      price += 750
    else
      price += 950
    end

    if number_declaration < 4
      price += 150
    else
      price += 250
    end
    @order.value = price * 100 # persist in minor units

    if !@order.save
      render 'new'
      return
    end
                                  
    redirect_to @order
  end

  def deploy_cant_pay_email
    @order = Order.includes(:order_lines, :addresses).find(params[:id])
    OrderMailer.no_paypal_account_email(@order).deliver_later

    notice = "Eine E-Mail wurde an Amavat gesendet. Sie werden in Kürze mit alternativen Zahlungsmethoden kontaktiert."
    flash[:success] = notice
    redirect_to new_order_path
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
    params.require(:order).permit(registrations: [:registration_germany, :registration_poland,
                                                  :registration_czech, :registration_austria,
                                                  :registration_spain, :registration_france, :registration_uk,
                                                  :registration_italy, :registration_other, :declaration_germany],
                                  declarations: [:declaration_poland, :declaration_czech, :declaration_austria,
                                                 :declaration_spain, :declaration_france, :declaration_uk,
                                                 :declaration_italy, :declaration_other])
  end
end
