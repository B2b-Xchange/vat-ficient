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

    # store order line params to variables for reuse
    r_de = order_line_params[:registrations][:registration_germany]
    r_pl = order_line_params[:registrations][:registration_poland]
    r_cz = order_line_params[:registrations][:registration_czech]
    r_at = order_line_params[:registrations][:registration_austria]
    r_es = order_line_params[:registrations][:registration_spain]
    r_fr = order_line_params[:registrations][:registration_france]
    r_uk = order_line_params[:registrations][:registration_uk]
    r_it = order_line_params[:registrations][:registration_italy]
    r_other = order_line_params[:registrations][:registration_other]
    
    if r_de == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "DE"})
    end

    if r_pl == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "PL"})
    end

    if r_cz == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "CZ"})
    end

    if r_at == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "AT"})
    end

    if r_es == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "ES"})
    end

    if r_fr == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "FR"})
    end

    if r_uk == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "UK"})
    end

    if r_it == "1"
      @order.order_lines.build({kind: 1, country_iso_code: "IT"})
    end

    if r_other == "1"
      @order.order_lines.build({kind: 1})
    end

    d_de = order_line_params[:declarations][:declaration_germany]
    d_pl = order_line_params[:declarations][:declaration_poland]
    d_cz = order_line_params[:declarations][:declaration_czech]
    d_at = order_line_params[:declarations][:declaration_austria]
    d_es = order_line_params[:declarations][:declaration_spain]
    d_fr = order_line_params[:declarations][:declaration_france]
    d_uk = order_line_params[:declarations][:declaration_uk]
    d_it = order_line_params[:declarations][:declaration_italy]
    d_other = order_line_params[:declarations][:declaration_other]
    
    if d_de == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "DE"})
    end

    if d_pl == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "PL"})
    end

    if d_cz == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "CZ"})
    end

    if d_at == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "AT"})
    end

    if d_es == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "ES"})
    end

    if d_fr == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "FR"})
    end

    if d_uk == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "UK"})
    end

    if d_it == "1"
      @order.order_lines.build({kind: 2, country_iso_code: "IT"})
    end

    if d_other == "1"
      @order.order_lines.build({kind: 2})
    end

    # error message when order positions make no sense
    combination_error_message = "Registrierung und Deklaration für das gleiche Land ist nicht möglich" 
    if ((r_de == "1" && d_de == "1") || (r_pl == "1" && d_pl == "1") ||
        (r_cz == "1" && d_cz == "1") || (r_at == "1" && d_at == "1") ||
        (r_es == "1" && d_es == "1") || (r_fr == "1" && d_fr == "1") ||
        (r_fr == "1" && d_fr == "1") || (r_uk == "1" && d_uk == "1") ||
        (r_it == "1" && d_it == "1"))
      @order.errors[:base] << combination_error_message
      render 'new'
      return
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

    if number_registration < 1
      price += 0
    elsif number_registration < 3
      price += 420
    elsif number_registration < 5
      price += 750
    else
      price += 950
    end

    if number_declaration < 1
      price += 0
    elsif number_declaration < 4
      price += 150
    else
      price += 250
    end

    # error message when no value
    no_value_error_message = "Es wurde keine Registrierung oder Deklaration ausgewählt"
    if price < 1
      @order.errors[:base] << no_value_error_message
      render 'new'
      return
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
