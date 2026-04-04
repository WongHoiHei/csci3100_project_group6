class DashboardStatsService
  def initialize(department)
    @department = department
  end

  def usage_rate
    total_slots = 4.0  # Mock total available
    booked_slots = @department.bookings.approved.count
    (booked_slots / total_slots * 100).round(1)
  end

  def bookings_by_date(start_date, end_date)
    @department.bookings
               .where(start_time: start_date.beginning_of_day..end_date.end_of_day)
               .group(:start_time)
               .count
  end
end