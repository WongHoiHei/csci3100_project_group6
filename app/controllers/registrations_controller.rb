class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.tenant ||= Tenant.first
    
    if @user.save
      flash[:notice] = 'Sign up successful! Please log in.'
      redirect_to login_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :tenant_id)
  end
end