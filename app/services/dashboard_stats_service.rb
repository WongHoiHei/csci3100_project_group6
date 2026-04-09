class DashboardStatsService
  def initialize(tenant)
    @tenant = tenant
  end

  def resource_usage_data
    {
      venues: format_usage(@tenant.venues),
      equipments: format_usage(@tenant.equipments)
    }
  end

  private

  def format_usage(collection)
    collection.map do |item|
      {
        name: item.name,
        # Polymorphic count through the bookings table
        usage_count: Booking.where(bookable: item, status: "approved").count
      }
    end
  end
end