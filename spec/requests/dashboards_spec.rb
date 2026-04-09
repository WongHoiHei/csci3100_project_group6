require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:engineering) { Tenant.create!(name: "Engineering Department") }
  let!(:lifescience) { Tenant.create!(name: "Life Science Department") }
  let!(:user) { User.create!(name: "Student", email: "s@link.cuhk.edu.hk", tenant: engineering, role: "student") }
  let!(:venue) { engineering.venues.create!(name: "SHB301") }

  describe "GET /dashboards.json" do
    it "returns correct counts for the selected tenant" do
      # Create 1 booking for engineering
      Booking.create!(user: user, bookable: venue, status: 'approved', start_time: Time.current, end_time: Time.current + 1.hour)

      # 1. Check Engineering
      get dashboards_path(format: :json, tenant_id: engineering.id)
      json = JSON.parse(response.body)
      expect(json["venues"].first["usage_count"]).to eq(1)

      # 2. Check Life Science (should be 0 or empty)
      get dashboards_path(format: :json, tenant_id: lifescience.id)
      json = JSON.parse(response.body)
      expect(json["venues"]).to be_empty
    end
  end
end