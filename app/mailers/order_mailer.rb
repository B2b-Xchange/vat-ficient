# coding: utf-8
class OrderMailer < ApplicationMailer
  default from: 'payment@b2bxchange.de'

  # if no PayPal button was hit, send mail with all details to Amavat contact person
  def no_paypal_account_email(order)
    @order = order
    mail(to: 'mh@b2bxchange.de', subject: 'Kein PayPal Konto für Amavat Bestellung')
  end
end
