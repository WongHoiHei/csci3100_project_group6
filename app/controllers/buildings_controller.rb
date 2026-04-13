class BuildingsController < ApplicationController
  layout false
  def show
    slug = params[:slug].to_s
    @location = Location.all.find { |loc| slugify_location_name(loc.name) == slug }

    if @location.blank?
      redirect_to map_path, alert: "Location not found."
      return
    end

    @official_name = @location.name
    @venues = @location.venues.includes(:time_slots).order(:name)

    @selected_date = begin
      params[:booking_date].present? ? Date.parse(params[:booking_date].to_s) : Date.current
    rescue ArgumentError
      Date.current
    end

    # Build a set of [venue_id, slot_id] pairs that are already booked on the selected date
    venue_ids = @venues.map(&:id)
    existing_bookings = Booking
      .where(bookable_type: "Venue", bookable_id: venue_ids)
      .where(start_time: @selected_date.beginning_of_day..@selected_date.end_of_day)
      .where.not(status: "rejected")
      .pluck(:bookable_id, :time_slot_id)

    @booked_slots = existing_bookings.to_set
  end

  private

  def slugify_location_name(name)
    name.to_s.downcase.gsub(/[^a-z0-9]+/, "")
  end
end