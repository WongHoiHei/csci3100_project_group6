class BookingsController < ApplicationController
  def venue
    @rooms = Venue.all
    @timeslots = (1..12).map { |i| "Period #{i}" }
  end

  def equipment
    @equipments = Equipment.all
    @time_slots = TimeSlot.order(:start_time)
  end

  def confirmation; end

  def finalize
    redirect_to "/booking/final"
  end

  def final; end

  def map
    render layout: false
  end

  def new
    @booking = Booking.new
    @bookable_id = params[:bookable_id]
    @bookable_type = params[:bookable_type]
    @time_slot_id = params[:time_slot_id]
    @time_slot = TimeSlot.find_by(id: @time_slot_id)

    return unless requires_time_slot?(@bookable_type)
    return if @time_slot.present?

    redirect_to missing_time_slot_redirect_path(@bookable_type), alert: "Please choose a valid time slot before booking."
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.status = "pending"
    assign_booking_times_from_time_slot(@booking)

    if Booking.new_conflict?(@booking.bookable_id, @booking.bookable_type, @booking.start_time, @booking.end_time)
      redirect_to "/bookings/new", alert: "Unavailable time slot"
    elsif @booking.save
      BookingMailer.confirmation(@booking).deliver_now
      sender_link = view_context.mail_to("venueandequipmentbooking@gmail.com", "venueandequipmentbooking@gmail.com")
      redirect_to equipment_booking_path, notice: "Booking request submitted. Email sent from #{sender_link}".html_safe
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
        sender_link = view_context.mail_to("venueandequipmentbooking@gmail.com", "venueandequipmentbooking@gmail.com")
        redirect_to bookings_path, notice: "Booking deleted. Email sent from #{sender_link}".html_safe
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
    params.require(:booking).permit(:bookable_id, :bookable_type, :time_slot_id)
  end

  def assign_booking_times_from_time_slot(booking)
    return if booking.time_slot_id.blank?

    time_slot = TimeSlot.find_by(id: booking.time_slot_id)
    return if time_slot.blank?

    booking.start_time = time_slot.start_time
    booking.end_time = time_slot.end_time
  end
end