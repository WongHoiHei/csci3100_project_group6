class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "venueandequipmentbooking@gmail.com")
  layout "mailer"
end
