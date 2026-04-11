class BuildingsController < ApplicationController
  def show
    slug = params[:slug].to_s
    @location = Location.all.find { |loc| slugify_location_name(loc.name) == slug }

    if @location.blank?
      redirect_to map_path, alert: "Location not found."
      return
    end

    @official_name = @location.name
    @venues = @location.venues.includes(:time_slots).order(:name)
  end

  private

  def slugify_location_name(name)
    name.to_s.downcase.gsub(/[^a-z0-9]+/, "")
  end
end