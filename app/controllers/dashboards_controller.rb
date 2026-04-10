class DashboardsController < ApplicationController
  def index
    @tenants = Tenant.all
    # Fallback to the first tenant if none is selected
    @selected_tenant = params[:tenant_id] ? Tenant.find(params[:tenant_id]) : Tenant.first
    
    @stats = DashboardStatsService.new(@selected_tenant).resource_usage_data

    respond_to do |format|
      format.html # Loads the initial layout
      format.json { render json: @stats } # Used by Stimulus for interactive updates
    end
  end
end