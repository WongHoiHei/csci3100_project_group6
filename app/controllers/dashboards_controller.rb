class DashboardsController < ApplicationController
  # Ensure the user is logged in before accessing analytics
  #before_action :require_user_logged_in! 

  def index
    # Use the Service Object you already tested
    @stats = DashboardStatsService.new(current_user.department)

    respond_to do |format|
      format.html # Renders index.html.haml
      format.json { render json: { 
        usage_rate: @stats.usage_rate, 
        bookings_data: @stats.bookings_by_date(7.days.ago, Time.current) 
      }}
    end
  end

  private

  # Define the missing method right here
  def require_user_logged_in!
    if session[:user_id].nil?
      redirect_to login_path, alert: "Please log in first."
    end
  end
end