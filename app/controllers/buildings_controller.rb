class BuildingsController < ApplicationController
  def show
    # Get the slug from the URL
    @slug = params[:slug]

    # Create a mapping of slugs to official names
    building_names = {
      "sirrunrunshawhall" => "Sir Run Run Shaw Hall",
      "nagym"             => "NA Gym",
      "ucgym"            => "UC Gym",
      "lingnanstadium"    => "Lingnan Stadium",
      "usportscentre"     => "University Sports Centre",
      "shawtheatre"       => "Shaw College Lecture Theatre"
    }

    # Find the official name based on the slug
    # If the slug isn't found, default to "Unknown Building"
    @official_name = building_names[@slug] || "Unknown Building"

    #find the venue under this building
    @venues=Venue.joins(:location).where(locations: {name: @official_name})
    puts "DEBUG: @official_name = #{@official_name}"
    puts "DEBUG: @venues count = #{@venues.count}"
    
    @timeslots = (1..12).map { |i| "Period #{i}" }
    render layout: false
  end
  
end