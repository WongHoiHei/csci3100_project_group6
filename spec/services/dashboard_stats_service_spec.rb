require 'rails_helper'

RSpec.describe DashboardStatsService, type: :service do
  let!(:tenant) { Tenant.create!(name: "General Department") }
  let!(:location) { Location.create!(name: "Main Campus") } 
  
  let!(:user) do 
    User.create!(
      name: "Test User",
      email: "test@example.com", 
      password: "password123",
      password_confirmation: "password123"
    )
  end

  # Order matters: Create the Venue first...
  let!(:venue_a) { Venue.create!(name: "Lab A", location: location) }
  let!(:venue_b) { Venue.create!(name: "Lab B", location: location) }
  let!(:equipment_a) { Equipment.create!(name: "Oscilloscope", tenant: tenant) }

  # ...then create the TimeSlot linked to that Venue
  let!(:time_slot) do
    TimeSlot.create!(
      venue: venue_a,
      start_time: Time.now,
      end_time: 2.hours.from_now
    )
  end

  describe "#resource_usage_data" do
    before do
      # 2 Valid Bookings
      2.times do 
        Booking.create!(
          bookable: venue_a, 
          user: user, 
          time_slot: time_slot,
          status: "approved", 
          start_time: Time.now, 
          end_time: 1.hour.from_now
        )
      end

      # 1 Rejected Booking (Ignored)
      Booking.create!(
        bookable: venue_a, 
        user: user, 
        time_slot: time_slot,
        status: "rejected", 
        start_time: Time.now, 
        end_time: 1.hour.from_now
      )

      # 1 Valid Equipment Booking
      Booking.create!(
        bookable: equipment_a, 
        user: user, 
        time_slot: time_slot,
        status: "pending", 
        start_time: Time.now, 
        end_time: 1.hour.from_now
      )
    end

    subject { DashboardStatsService.new.resource_usage_data }

    it "counts only non-rejected bookings for venues" do
      venue_data = subject[:venues].find { |v| v[:name] == "Lab A" }
      expect(venue_data[:usage_count]).to eq(2)
    end

    it "returns 0 for resources with no bookings" do
      venue_data = subject[:venues].find { |v| v[:name] == "Lab B" }
      expect(venue_data[:usage_count]).to eq(0)
    end

    it "counts only non-rejected bookings for equipment" do
      equip_data = subject[:equipments].find { |e| e[:name] == "Oscilloscope" }
      expect(equip_data[:usage_count]).to eq(1)
    end

    it "orders results by name alphabetically" do
      venue_names = subject[:venues].map { |v| v[:name] }
      expect(venue_names).to eq(venue_names.sort)
    end
  end
end