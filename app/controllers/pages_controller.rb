class PagesController < ApplicationController
  def welcome
    @hide_header = true
  end
  def main; end
  def map
    # This line tells Rails: "Do NOT use application.html.erb for this action"
    render layout: false 
  end
end