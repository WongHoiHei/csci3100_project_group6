class DashboardsController < ApplicationController
  def index
    @stats = DashboardStatsService.new.resource_usage_data

    respond_to do |format|
      format.html # Loads the initial layout
      format.json { render json: @stats } # Used by Stimulus for interactive updates
    end
  end
end