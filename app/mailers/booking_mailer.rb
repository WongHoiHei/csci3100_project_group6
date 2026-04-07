class BookingMailer < ApplicationMailer
  def confirmation(booking)
    @booking = booking
    @user = booking.user
    mail(to: @user.email, subject: 'Booking Confirmation')
  end

  def deletion(booking)
    @booking = booking
    @user = booking.user
    mail(to: @user.email, subject: 'Booking Cancellation')
  end
end