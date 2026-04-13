require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  # 1. Setup fundamental data
  let!(:tenant) { Tenant.create!(name: "Engineering Department") }
  let!(:location) { Location.create!(name: "Main Campus") } 
  
  # 2. Setup Resources
  let!(:venue) { Venue.create!(name: "SHB301", location: location) }
  let!(:equipment) { Equipment.create!(name: "Projector", tenant: tenant) }

  # 3. Setup User with manual auth requirements
  let!(:user) do 
    User.create!(
      name: "Test Admin", 
      email: "admin@example.com", 
      password: "password123", 
      password_confirmation: "password123"
    ) 
  end
  
  # 4. Setup TimeSlot required by Booking validations
  let!(:time_slot) do 
    TimeSlot.create!(
      venue: venue, 
      start_time: Time.now, 
      end_time: 2.hours.from_now
    ) 
  end

  describe "GET /dashboards.json" do
    before do
      # MANUAL AUTHENTICATION STEP
      # This simulates a user filling out the login form.
      post "/login", params: { email: user.email, password: "password123" }
      
      # Verify the login worked before proceeding
      follow_redirect! if response.redirect?

      # 5. Create valid bookings to be counted by the service
      5.times do
        Booking.create!(
          bookable: venue, 
          user: user, 
          time_slot: time_slot, 
          status: "approved",
          start_time: Time.now, 
          end_time: 1.hour.from_now
        )
      end

      12.times do
        Booking.create!(
          bookable: equipment, 
          user: user, 
          time_slot: time_slot, 
          status: "pending",
          start_time: Time.now, 
          end_time: 1.hour.from_now
        )
      end

      # 6. Create a rejected booking to test the 'where.not' filter logic
      Booking.create!(
        bookable: venue, 
        user: user, 
        time_slot: time_slot, 
        status: "rejected",
        start_time: Time.now, 
        end_time: 1.hour.from_now
      )
    end

    it "returns correct real-time counts from the DashboardStatsService" do
      # Hit the endpoint
      get "/dashboards.json"
      
      # Should now be 200 OK because the 'post /login' created a session
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      
      # Verify Venue stats (5 approved, 1 rejected ignored)
      venue_resp = json["venues"].find { |v| v["name"] == "SHB301" }
      expect(venue_resp["usage_count"]).to eq(5)
      
      # Verify Equipment stats (12 pending/approved)
      equip_resp = json["equipments"].find { |e| e["name"] == "Projector" }
      expect(equip_resp["usage_count"]).to eq(12)
    end
  end
end