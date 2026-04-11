class DashboardsController < ApplicationController
  def index
    @tenants = Tenant.all
    selected_tenant_id = params[:tenant_id].presence
    @selected_tenant = selected_tenant_id ? Tenant.find_by(id: selected_tenant_id) : Tenant.first
    
    @stats = DashboardStatsService.new(@selected_tenant).resource_usage_data

    respond_to do |format|
      format.html # Loads the initial layout
      format.json { render json: @stats } # Used by Stimulus for interactive updates
    end
  end
end