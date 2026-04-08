class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = 'Logged in successfully!'
      redirect_to main_path
    else
      flash[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    flash[:notice] = 'Logged out successfully!'
    redirect_to welcome_path
  end
end