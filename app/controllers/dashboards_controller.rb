class DashboardsController < ApplicationController
  def index
    render json: {
      usage_rate: 75.0,
      bookings_data: { '2026-04-01' => 2, '2026-04-02' => 1 }
    }
  end
end
