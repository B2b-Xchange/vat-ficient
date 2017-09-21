class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_ACCOUNT']
  layout 'mailer'
end
