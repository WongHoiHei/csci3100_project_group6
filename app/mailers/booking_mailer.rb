class BookingMailer < ApplicationMailer
  
  #default from: 'no-reply@cuhkBooking.app'

  #def password_changed(user, new_password)
  #  @user = user
  #  @new_password = new_password
  #
  #  mail(to: @user.email, subject: "Your password has been changed")
  #end

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