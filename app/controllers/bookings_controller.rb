class BookingsController < ApplicationController
  def venue
    @rooms = Venue.all
    @timeslots = (1..12).map { |i| "Period #{i}" }
  end

  def equipment
    @equipments = Equipment.all
  end

  def confirmation; end

  def finalize  
    redirect_to '/booking/final'  
  end

  def final; end
  
   def map
    render layout:false
  end

  #show booking form
  def new
    @booking =Booking.new #create a new booking form named booking
    @bookable_id =params[:bookable_id] #input id
    @bookable_type=params[:bookable_type] #inpur type 
  end

  #save booking
  def create
    @booking =Booking.new (booking_params)
    @booking.user =current_user 
    @booking.status ="pending"

    #check available
    if Booking.new_conflict?(@booking.bookable_id, @booking.bookable_type, @booking.start_time, @booking.end_time)
      redirect_to '/bookings/new', alert: "Unavailable time slot"
    elsif @booking.save
      BookingMailer.confirmation(@booking).deliver_later
      sender_link = view_context.mail_to('from@example.com', 'from@example.com')
      redirect_to "/bookings/#{@booking.id}", notice: "Booking request submitted. Email sent from #{sender_link}".html_safe
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show 
    @booking =Booking.find(params[:id])
  end

  #show all booking
  def index
    @bookings =current_user.bookings
  end

  def destroy
    @booking = Booking.find(params[:id])
    if @booking.user == current_user
      BookingMailer.deletion(@booking).deliver_later
      @booking.destroy
      sender_link = view_context.mail_to('from@example.com', 'from@example.com')
      redirect_to bookings_path, notice: "Booking deleted. Email sent from #{sender_link}".html_safe
    else
      redirect_to bookings_path, alert: "Unauthorized"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:bookable_id, :bookable_type, :start_time, :end_time)
  end



end