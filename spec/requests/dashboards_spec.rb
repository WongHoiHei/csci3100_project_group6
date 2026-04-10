require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:engineering) { Tenant.create!(name: "Engineering Department") }
  let!(:lifescience) { Tenant.create!(name: "Life Science Department") }
  
  # We set the counts directly on the records to test the Service's ability to retrieve them
  let!(:venue) { engineering.venues.create!(name: "SHB301", booking_count: 5) }
  let!(:equipment) { engineering.equipments.create!(name: "Projector", usage_count: 12) }

  describe "GET /dashboards.json" do
    it "returns correct counts for the selected tenant" do
      # 1. Check Engineering Department
      get dashboards_path(format: :json, tenant_id: engineering.id)
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      
      # Verify venue booking_count is mapped to usage_count for the frontend
      expect(json["venues"].first["name"]).to eq("SHB301")
      expect(json["venues"].first["usage_count"]).to eq(5)
      
      # Verify equipment usage_count
      expect(json["equipments"].first["name"]).to eq("Projector")
      expect(json["equipments"].first["usage_count"]).to eq(12)

      # 2. Check Life Science Department (should be empty as no resources were created for it)
      get dashboards_path(format: :json, tenant_id: lifescience.id)
      json = JSON.parse(response.body)
      
      expect(json["venues"]).to be_empty
      expect(json["equipments"]).to be_empty
    end
  end
end