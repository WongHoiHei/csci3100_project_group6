class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", ENV.fetch("SMTP_USERNAME", "venueandequipmentbooking@gmail.com"))
  layout "mailer"
end
