class SearchController < ApplicationController
  def index
    @query = params[:q]
    @time_slots = TimeSlot.order(:start_time)
    
    if @query.present?
      @equipment_results = Equipment.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
      @venue_results = Venue.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
    else
      @equipment_results = []
      @venue_results = []
    end
  end
end