class RegistrationsController < ApplicationController
  def new
    @hide_header = true
  end

  def create
    flash[:notice] = 'Sign up successful'
    redirect_to login_path
  end
end