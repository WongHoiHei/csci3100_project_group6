class ApplicationMailer < ActionMailer::Base
  #default from: ENV.fetch("SMTP_FROM_ADDRESS", ENV.fetch("SMTP_USERNAME", "no-reply@example.com"))
  default from: "example@booking.com"
  layout "mailer"
end
