class UserMailer < ApplicationMailer
    default from: "example@booking.com"
    def password_changed(user, new_password)
        @user = user
        @new_password = new_password

        mail(
            to: @user.email, 
            subject: "Your password has been changed",
        )
    end
end
