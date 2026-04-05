require 'ostruct'

class DashboardsController < ApplicationController
  def index
    @stats = dashboard_stats
    
    respond_to do |format|
      format.html  # Chart.js dashboard
      format.json { render json: stats_data }
    end
  end

  private

  def dashboard_stats
    mock_dept = Struct.new(:bookings).new(mock_bookings)
    DashboardStatsService.new(mock_dept)
  end

  def stats_data
    {
      usage_rate: @stats.usage_rate,
      bookings_data: @stats.bookings_by_date(7.days.ago, Time.current)
    }
  end

  def mock_bookings
    Struct.new(:approved, :where).new(
      Struct.new(:count).new(3),  # approved.count → 3
      Struct.new(:group).new(
        Struct.new(:count).new({ "2026-04-01" => 2, "2026-04-02" => 1 })
      )
    )
  end
end