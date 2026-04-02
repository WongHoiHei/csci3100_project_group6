class PasswordsController < ApplicationController
  def edit; end

  def update
    redirect_to login_path
  end
end