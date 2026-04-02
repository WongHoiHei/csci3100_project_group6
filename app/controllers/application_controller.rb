require 'ostruct'

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    OpenStruct.new(name: 'Demo User', email: 'demo@example.com')
  end

  def logged_in?
    true
  end
end