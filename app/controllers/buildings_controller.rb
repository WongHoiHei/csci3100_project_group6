class BuildingsController < ApplicationController
  def show
    # Get the slug from the URL
    @slug = params[:slug]

    # Create a mapping of slugs to official names
    building_names = {
      "sirrunrunshawhall" => "Sir Run Run Shaw Hall",
      "nagym"             => "New Asia College Gymnasium",
      "ucgym"            => "United College Gymnasium",
      "lingnanstadium"    => "Lingnan Stadium",
      "usportscentre"     => "University Sports Centre",
      "shawtheatre"       => "Shaw College Lecture Theatre"
    }

    # Find the official name based on the slug
    # If the slug isn't found, default to "Unknown Building"
    @official_name = building_names[@slug] || "Unknown Building"
    render layout: false
  end
end