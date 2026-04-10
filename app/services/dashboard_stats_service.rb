class DashboardStatsService
  def initialize(tenant)
    @tenant = tenant
  end

  def resource_usage_data
    {
      venues: @tenant.venues.map { |v| { name: v.name, usage_count: v.booking_count || 0 } },
      equipments: @tenant.equipments.map { |e| { name: e.name, usage_count: e.usage_count || 0 } }
    }
  end
end