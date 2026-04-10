class DashboardStatsService
  def initialize(tenant)
    @tenant = tenant
  end

  def resource_usage_data
    equipments_scope = @tenant.present? ? @tenant.equipments : Equipment.all

    {
      venues: Venue.all.map { |v| { name: v.name, usage_count: v.number_of_past_booking || 0 } },
      equipments: equipments_scope.map { |e| { name: e.name, usage_count: e.number_of_past_booking || 0 } }
    }
  end
end