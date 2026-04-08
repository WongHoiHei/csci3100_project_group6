class PasswordsController < ApplicationController
  before_action :require_login

  def edit; end

  def update
    @user = current_user
    
    if @user.authenticate(params[:password_current])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = 'Password changed successfully!'
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