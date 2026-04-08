class PasswordsController < ApplicationController
  def edit
    @hide_header = true
  end

  def update
    redirect_to login_path
  end
end