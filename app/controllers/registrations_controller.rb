class RegistrationsController < ApplicationController
  def new; end

  def create
    flash[:notice] = 'Sign up successful'
    redirect_to login_path
  end
end