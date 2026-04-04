class DashboardStatsService
  def initialize(department)
    @department = department
  end

  def usage_rate
    total_slots = 4.0  # Mock total available
    booked_slots = @department.bookings.approved.count
    (booked_slots / total_slots * 100).round(1)
  end
end