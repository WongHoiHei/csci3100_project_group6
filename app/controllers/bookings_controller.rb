class BookingsController < ApplicationController
  def venue
    @rooms = ['Room A']
    @timeslots = (1..12).map { |i| "Period #{i}" }
  end

  def equipment
    @equipments = [
      { name: 'Projector', available: true, category: 'Presentation' },
      { name: 'Speaker', available: true, category: 'Audio' },
      { name: 'Microphone', available: false, category: 'Audio' }
    ]
  end

  def confirmation; end

  def finalize  
    redirect_to '/booking/final'  
  end

  def final; end
end