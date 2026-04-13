require 'sendgrid-actionmailer'

ActionMailer::Base.add_delivery_method(
  :sendgrid_actionmailer,
  SendGridActionMailer::DeliveryMethod
)