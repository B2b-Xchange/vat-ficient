# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def no_paypal_account_email
    order = Order.includes(:order_lines, :addresses).find(11)
    OrderMailer.no_paypal_account_email order
  end
end
