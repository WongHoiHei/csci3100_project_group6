require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  # --- 1. Setup Data ---
  let!(:tenant) { Tenant.create!(name: "Engineering Department") }
  let!(:location) { Location.create!(name: "Main Campus") } 
  let!(:venue) { Venue.create!(name: "SHB301", location: location) }
  let!(:equipment) { Equipment.create!(name: "Projector", tenant: tenant) }

  let!(:user) do 
    User.create!(
      name: "Test Admin", 
      email: "admin@example.com", 
      password: "password123", 
      password_confirmation: "password123"
    ) 
  end
  
  let!(:time_slot) do 
    TimeSlot.create!(
      venue: venue, 
      start_time: Time.now, 
      end_time: 2.hours.from_now
    ) 
  end

  # --- 2. Security Path ---
  describe "GET /dashboards (Unauthorized)" do
    it "redirects to the login page if session is missing" do
      get "/dashboards"
      expect(response).to redirect_to("/login")
    end
  end

  # --- 3. Authenticated Paths ---
  describe "Authorized Access" do
    before do
      # Simulate login to create session
      post "/login", params: { email: user.email, password: "password123" }
      follow_redirect! if response.redirect?

      # Create test bookings
      # 5 Approved (Counted)
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

      # 1 Rejected (Ignored)
      Booking.create!(
        bookable: venue, 
        user: user, 
        time_slot: time_slot, 
        status: "rejected",
        start_time: Time.now, 
        end_time: 1.hour.from_now
      )
    end

    context "HTML Format" do
      it "renders the dashboard index successfully" do
        get "/dashboards"
        expect(response).to have_http_status(:success)
        # Verifies the HAML server-side rendering is working
        expect(response.body).to include("Booking Data")
        expect(response.body).to include("SHB301")
        expect(response.body).to include("Projector")
      end
    end

    context "JSON Format" do
      it "returns correct counts for Stimulus.js components" do
        get "/dashboards.json"
        expect(response).to have_http_status(:success)
        
        json = JSON.parse(response.body)
        
        # Verify specific venue count logic
        venue_resp = json["venues"].find { |v| v["name"] == "SHB301" }
        expect(venue_resp["usage_count"]).to eq(5)
        
        # Verify structure for Chart.js/Stimulus
        expect(json).to have_key("venues")
        expect(json).to have_key("equipments")
      end
    end
  end
end