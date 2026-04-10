class PasswordsController < ApplicationController
  before_action :require_login

  
  def edit
    @hide_header = true
  end

  def update
    @user = current_user
    
    if @user.authenticate(params[:password_current])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        begin
          UserMailer.password_changed(@user, params[:password]).deliver_now
          flash[:notice] = 'Password changed successfully! A confirmation email has been sent.'
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPUnknownError, SocketError => e
          Rails.logger.error("Password changed, but confirmation email failed for user #{
            @user.id
          }: #{e.class} - #{e.message}")
          flash[:alert] = 'Password changed successfully, but confirmation email failed to send. Please check SMTP settings.'
        end
        redirect_to main_path
      else
        flash[:alert] = @user.errors.full_messages.join(', ')
        render :edit
      end
    else
      flash[:alert] = 'Current password is incorrect'
      render :edit
    end
  end
end