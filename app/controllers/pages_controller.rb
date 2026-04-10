class PagesController < ApplicationController
  skip_before_action :require_login, only: [:welcome]

  def welcome
    redirect_to main_path if logged_in?
    @hide_header = true
  end

  def main; end

  def map
    # This line tells Rails: "Do NOT use application.html.erb for this action"
    render layout: false 
  end
  
  def main; end
end