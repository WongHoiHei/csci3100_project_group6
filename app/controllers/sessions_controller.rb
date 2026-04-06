class SessionsController < ApplicationController
  def new
    @hide_header = true  
  end

  def create
    redirect_to main_path
  end

  def destroy
    redirect_to root_path
  end
end