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
end