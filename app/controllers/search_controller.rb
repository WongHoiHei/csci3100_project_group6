class SearchController < ApplicationController
  def index
    @query = params[:q]
    @time_slots = TimeSlot.order(:start_time)
    
    if @query.present?
      @equipment_results = Equipment.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
      @venue_results = Venue.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
    
      # Mock search results --> (p) change to read from database
      # case @query&.downcase
      # when 'projector'
      #   @results = ['Projector A (Available)', 'Projector B (Unavailable)']
      # when 'room', 'venue'
      #   @results = ['Room A (12 slots)', 'Room B (8 slots)']
      # when 'speaker'
      #   @results = ['Wireless Speaker', 'Conference Speaker']
      # else
      #   @results = []
      # end

    
      # if @query.present?   #if user enter search
      #   @results =Equipment.where("name LIKE ?", @query.downcase)
    else
      @equipment_results = []
      @venue_results = []
    end
  end
end