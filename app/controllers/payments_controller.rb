# coding: utf-8
class PaymentsController < ApplicationController

  require 'paypal-sdk-rest'
  
  # paypal execute callback (no order id)
  def execute

    payment_to_execute = PayPal::SDK::REST::Payment.find(params['paymentId'])
    if payment_to_execute.execute(:payer_id => params['PayerID'])
      # use find again to load all information
      payment_to_execute = PayPal::SDK::REST::Payment.find(params['paymentId'])
      # success
      # find payment with payment referece and set new sale payment reference and set order to paid
      @payment = Payment.include(:order).find(transaction_reference: params['paymentId'])
      @payment.transaction_reference = payment_to_execute.transactions[0].related_resources[0].sale.id
      @payment.kind = 2
      @payment.order.paid_time = Time.current
      @payment.save
    else
      payment_to_execute.error.inspect
    end
    
  end

  # paypal cancel callback (no order id)
  def cancel
    flash[:warning] = "Der Zahlungsvorgang wurde abgebrochen. Sie können jederzeit eine neue Bestellung aufgeben oder diese Bestellung bezahlen."
    redirect_to new_order_path
  end
  
  def create
       
    PayPal::SDK::REST.set_config(
      :mode => ENV['PAYPAL_MODE'],
      :client_id => ENV['PAYPAL_CLIENT_ID'],
      :client_secret => ENV['PAYPAL_CLIENT_SECRET'])

    # build payment object
    order = Order.find(params[:order_id])
    @payment = PayPal::SDK::REST::Payment
                 .new({
                        :intent => "sale",
                        :payee => {
                          :email => "paypal@amavat.eu"
                        },
                        :payer => {
                          :payment_method => "paypal"
                        },
                        :redirect_urls => {
                          :return_url => ENV['PAYPAL_RETURN_URL'],
                          :cancel_url => ENV['PAYPAL_CANCEL_URL']
                        },
                        :transactions => [{
                                            :item_list => {
                                              :items => [{
                                                           :name => "Amavat Voranzahlung",
                                                           :sku => "1",
                                                           :price => (order.value / 100).to_s,
                                                           :currency => "EUR",
                                                           :quantity => 1
                                                         }]
                                            },
                                            :amount => {
                                              :total => (order.value / 100).to_s,
                                              :currency => "EUR"
                                            },
                                            :description => "Voranzahlung für Bestellung " + order.number
                                          }]
                      })

    if @payment.create
      # create payment in db
      order.payment.create({payment_type: 1,
                            kind: 1,
                            status: 1,
                            transaction_reference: @payment.id })
      
      # redirect to approval url
      @payment.links.each do |link|
        if link.rel == "approval_url"
          redirect_to link.href
        end
      end
    else
      @payment.error.inspect
    end
  end
end
