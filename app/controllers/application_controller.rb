require 'ostruct'

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user  ||=User.first #test (User.find_by(id:session[:user_id]))
  end

  def logged_in?
    true
  end
end