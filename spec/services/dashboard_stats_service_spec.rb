require 'rails_helper'

RSpec.describe DashboardStatsService do
  let(:engineering) { Tenant.create!(name: "Engineering") }
  
  # Update: We now set the counts directly because the Service reads from columns
  let!(:venue) { engineering.venues.create!(name: "SHB301", location: "Building A", booking_count: 2) }
  let!(:equipment) { engineering.equipments.create!(name: "Projector", usage_count: 15) }
  
  subject { DashboardStatsService.new(engineering) }

  describe "#resource_usage_data" do
    let(:results) { subject.resource_usage_data }

    it "retrieves the cached booking_count for venues" do
      shb_stat = results[:venues].find { |v| v[:name] == "SHB301" }
      
      # The service should now simply return the value stored in the column
      expect(shb_stat[:usage_count]).to eq(2)
    end

    it "retrieves the cached usage_count for equipment" do
      projector_stat = results[:equipments].find { |e| e[:name] == "Projector" }
      
      expect(projector_stat[:usage_count]).to eq(15)
    end

    it "defaults to 0 when no booking_count is provided" do
      # We don't pass booking_count at all; the database default (0) should kick in
      new_venue = engineering.venues.create!(name: "Empty Room", location: "Building B")
      
      updated_results = subject.resource_usage_data
      empty_stat = updated_results[:venues].find { |v| v[:name] == "Empty Room" }
      
      expect(empty_stat[:usage_count]).to eq(0)
    end
  end
end