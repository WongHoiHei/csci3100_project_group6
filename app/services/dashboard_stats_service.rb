class DashboardStatsService
  def resource_usage_data
    venue_usage_counts = Booking.where(bookable_type: "Venue")
                               .where.not(status: "rejected")
                               .group(:bookable_id)
                               .count

    equipment_usage_counts = Booking.where(bookable_type: "Equipment")
                                   .where.not(status: "rejected")
                                   .group(:bookable_id)
                                   .count

    {
      venues: Venue.order(:name).map { |v| { name: v.name, usage_count: venue_usage_counts[v.id] || 0 } },
      equipments: Equipment.order(:name).map { |e| { name: e.name, usage_count: equipment_usage_counts[e.id] || 0 } }
    }
  end
end