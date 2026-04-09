require 'rails_helper'

RSpec.describe DashboardStatsService do
  # 1. Setup the necessary data
  let(:engineering) { Tenant.create!(name: "Engineering") }
  
  # We need a user because the Booking migration requires one
  let(:user) { User.create!(name: "Test Student", email: "test@link.cuhk.edu.hk", role: "student", tenant: engineering) }
  
  let(:venue) { engineering.venues.create!(name: "SHB301", location: "Building A") }
  
  subject { DashboardStatsService.new(engineering) }

  it "calculates the total usage count for venues" do
    # 2. Create bookings associated with the user and the bookable venue
    Booking.create!(
      user: user, 
      bookable: venue, 
      status: 'approved', 
      start_time: Time.current, 
      end_time: Time.current + 1.hour
    )
    
    Booking.create!(
      user: user, 
      bookable: venue, 
      status: 'approved', 
      start_time: Time.current + 2.hours, 
      end_time: Time.current + 3.hours
    )

    # 3. Assert the count
    results = subject.resource_usage_data
    shb_stat = results[:venues].find { |v| v[:name] == "SHB301" }
    
    expect(shb_stat[:usage_count]).to eq(2)
  end
end