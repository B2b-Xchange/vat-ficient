# coding: utf-8
class OrderMailer < ApplicationMailer
  default from: ENV['MAIL_ACCOUNT']

  # if no PayPal button was hit, send mail with all details to Amavat contact person
  def no_paypal_account_email(order)
    @order = order
    mail(to: ENV['NO_PAYPAL_EMAIL_ADDRESS'], subject: 'Kein PayPal Konto für Amavat Bestellung')
  end
end
