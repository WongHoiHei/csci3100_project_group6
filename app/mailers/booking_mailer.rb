class BookingMailer < ApplicationMailer
  
  #default from: 'no-reply@cuhkBooking.app'
  default from: ENV.fetch("MAIL_FROM", "venueandequipmentbooking@gmail.com")
  #def password_changed(user, new_password)
  #  @user = user
  #  @new_password = new_password
  #
  #  mail(to: @user.email, subject: "Your password has been changed")
  #end

  def confirmation(booking)
    @booking = booking
    @user = booking.user
    set_display_times
    mail(to: @user.email, subject: 'Booking Confirmation')
  end

  def deletion(booking)
    @booking = booking
    @user = booking.user
    set_display_times
    mail(to: @user.email, subject: 'Booking Cancellation')
  end

  private

  def set_display_times
    start_time = @booking.start_time || @booking.time_slot&.start_time
    end_time = @booking.end_time || @booking.time_slot&.end_time

    @display_start_time = formatted_time_or_na(start_time)
    @display_end_time = formatted_time_or_na(end_time)
  end

  def formatted_time_or_na(value)
    return 'N/A' if value.blank?

    value.strftime('%Y-%m-%d %H:%M')
  end
end