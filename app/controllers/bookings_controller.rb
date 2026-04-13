class BookingsController < ApplicationController
  def venue
    @rooms = Venue.all
    @timeslots = (1..12).map { |i| "Period #{i}" }
  end

  def equipment
    @selected_date = parse_booking_date(params[:booking_date]) || Date.current
    @search_query = params[:q]
    
    @equipments = Equipment.all.distinct
    
    if @search_query.present?
      @equipments = @equipments.where("LOWER(name) LIKE ?", "%#{@search_query.downcase}%")
    end
    
    @time_slots = TimeSlot.select("MIN(id) as id, start_time, end_time")
                          .group(:start_time, :end_time)
                          .order(:start_time)
    @remaining_quantity_by_equipment_and_slot = build_remaining_quantity_map(@selected_date)
  end

  def confirmation
    @bookable_id = params[:bookable_id]
    @bookable_type = params[:bookable_type]
    @time_slot_id = params[:time_slot_id]
    @booking_date = params[:booking_date]
    @time_slot = TimeSlot.find_by(id: @time_slot_id)
  end

  def finalize
    redirect_to "/booking/final"
  end

  def final; end

  def map
    @map_locations = Location.order(:name).map do |location|
      {
        lat: location.latitude,
        lng: location.longitude,
        title: location.name,
        slug: slugify_location_name(location.name),
        venue_count: location.venues.count,
        image_url: nil
      }
    end

    render layout: false
  end

  def new
    @booking = Booking.new
    @bookable_id = params[:bookable_id]
    @bookable_type = params[:bookable_type]
    @time_slot_id = params[:time_slot_id]
    @booking_date = params[:booking_date]
    @time_slot = TimeSlot.find_by(id: @time_slot_id)

    return unless requires_time_slot?(@bookable_type)
    return if @time_slot.present?

    redirect_to missing_time_slot_redirect_path(@bookable_type), alert: "Please choose a valid time slot before booking."
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.status = "success"
    assign_booking_times_from_time_slot(@booking)

    if equipment_unavailable_for_selected_slot?(@booking)
      redirect_to equipment_booking_path(booking_date: extracted_booking_date(@booking)), alert: "This equipment is fully booked for the selected date and time slot."
    elsif Booking.new_conflict?(@booking.bookable_id, @booking.bookable_type, @booking.start_time, @booking.end_time)
      redirect_to "/bookings/new", alert: "Unavailable time slot"
    elsif @booking.save
      BookingMailer.confirmation(@booking).deliver_now
      mail_sender = ENV.fetch("MAIL_FROM", "venueandequipmentbooking@gmail.com")
      success_notice = "Booking request submitted. Email sent from #{mail_sender}".html_safe

      if @booking.bookable_type == "Venue"
        redirect_to bookings_path, notice: success_notice
      else
        redirect_to equipment_booking_path, notice: success_notice
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def index
    @bookings = current_user.bookings.order(created_at: :desc)
    @search_query = params[:q]
    
    if @search_query.present?
      query = "%#{@search_query.downcase}%"
      equipment_ids = Equipment.where("LOWER(name) LIKE ?", query).pluck(:id)
      venue_ids = Venue.where("LOWER(name) LIKE ?", query).pluck(:id)
      
      if equipment_ids.any? || venue_ids.any?
        @bookings = @bookings.where(
          "bookable_type = 'Equipment' AND bookable_id IN (:equipment_ids) OR bookable_type = 'Venue' AND bookable_id IN (:venue_ids)",
          equipment_ids: equipment_ids,
          venue_ids: venue_ids
        )
      else
        @bookings = @bookings.where(id: nil)
      end
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    if @booking.user == current_user
      if @booking.destroy
        BookingMailer.deletion(@booking).deliver_now
        mail_sender = ENV.fetch("MAIL_FROM", "venueandequipmentbooking@gmail.com")
        redirect_to bookings_path, notice: "Booking deleted. Email sent from #{mail_sender}".html_safe
      else
        redirect_to bookings_path, alert: "Unable to cancel booking."
      end
    else
      redirect_to bookings_path, alert: "Unauthorized"
    end
  end

  private

  def requires_time_slot?(bookable_type)
    ["Venue", "Equipment"].include?(bookable_type)
  end

  def missing_time_slot_redirect_path(bookable_type)
    return equipment_booking_path if bookable_type == "Equipment"

    venue_booking_path
  end

  def booking_params
    params.require(:booking).permit(:bookable_id, :bookable_type, :time_slot_id, :booking_date)
  end

  def assign_booking_times_from_time_slot(booking)
    return if booking.time_slot_id.blank?

    time_slot = TimeSlot.find_by(id: booking.time_slot_id)
    return if time_slot.blank?

    booking_date = parse_booking_date(booking.booking_date)
    if booking_date.present?
      booking.start_time = combine_date_and_time(booking_date, time_slot.start_time)
      booking.end_time = combine_date_and_time(booking_date, time_slot.end_time)
    else
      booking.start_time = time_slot.start_time
      booking.end_time = time_slot.end_time
    end
  end

  def equipment_unavailable_for_selected_slot?(booking)
    return false unless booking.bookable_type == "Equipment"

    booking_date = extracted_booking_date(booking)
    return false if booking_date.blank?

    capacity = equipment_capacity_for(booking.bookable_id)
    return true if capacity <= 0

    booked_count = Booking.where(bookable_type: "Equipment", bookable_id: booking.bookable_id, time_slot_id: booking.time_slot_id)
                        .where(start_time: booking_date.beginning_of_day..booking_date.end_of_day)
                        .where.not(status: "rejected")
                        .count

    booked_count >= capacity
  end

  def build_remaining_quantity_map(selected_date)
    counts = Booking.where(bookable_type: "Equipment", time_slot_id: @time_slots.map(&:id))
                    .where(start_time: selected_date.beginning_of_day..selected_date.end_of_day)
                    .where.not(status: "rejected")
                    .group(:bookable_id, :time_slot_id)
                    .count

    result = {}
    @equipments.each do |equipment|
      capacity = equipment_capacity_for(equipment)
      @time_slots.each do |slot|
        booked_count = counts.fetch([equipment.id, slot.id], 0)
        result[[equipment.id, slot.id]] = [capacity - booked_count, 0].max
      end
    end

    result
  end

  def equipment_capacity_for(equipment_or_id)
    equipment = equipment_or_id.is_a?(Equipment) ? equipment_or_id : Equipment.find_by(id: equipment_or_id)
    return 0 if equipment.blank?

    capacity = equipment.available_count.nil? ? equipment.total_count : equipment.available_count
    capacity.to_i
  end

  def extracted_booking_date(booking)
    return booking.start_time.to_date if booking.start_time.present?

    parse_booking_date(booking.booking_date)
  end

  def combine_date_and_time(date_value, time_value)
    Time.zone.local(
      date_value.year,
      date_value.month,
      date_value.day,
      time_value.hour,
      time_value.min,
      time_value.sec
    )
  end

  def parse_booking_date(value)
    return if value.blank?

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def slugify_location_name(name)
    name.to_s.downcase.gsub(/[^a-z0-9]+/, "")
  end
end