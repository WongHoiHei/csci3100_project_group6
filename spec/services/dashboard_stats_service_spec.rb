require 'rails_helper'

RSpec.describe DashboardStatsService, type: :service do
  let(:tenant) { Tenant.create!(name: "Engineering") }
  let(:other_tenant) { Tenant.create!(name: "Marketing") }
  
  # Setup venues (Note: Venue belongs to Location in your setup)
  let(:location) { Location.create!(name: "Main Campus", tenant: tenant) }
  let!(:venue) { Venue.create!(name: "Lab A", location: location, number_of_past_booking: 10) }
  let!(:other_venue) { Venue.create!(name: "Conference Room", location: Location.create!(tenant: other_tenant), number_of_past_booking: 5) }

  # Setup equipment
  let!(:equipment) { Equipment.create!(name: "Oscilloscope", tenant: tenant, number_of_past_booking: 25) }
  let!(:other_equipment) { Equipment.create!(name: "Projector", tenant: other_tenant, number_of_past_booking: 2) }

  subject { DashboardStatsService.new(tenant) }

  describe "#resource_usage_data" do
    let(:data) { subject.resource_usage_data }

    it "returns the cached booking counts for venues (currently global)" do
      # Since your service currently uses Venue.all, it should see both
      venue_names = data[:venues].map { |v| v[:name] }
      expect(venue_names).to include("Lab A", "Conference Room")
      
      lab_a = data[:venues].find { |v| v[:name] == "Lab A" }
      expect(lab_a[:usage_count]).to eq(10)
    end

    it "returns only equipment belonging to the selected tenant" do
      equipment_names = data[:equipments].map { |e| e[:name] }
      
      expect(equipment_names).to include("Oscilloscope")
      expect(equipment_names).not_to include("Projector")
      
      oscilloscope = data[:equipments].find { |e| e[:name] == "Oscilloscope" }
      expect(oscilloscope[:usage_count]).to eq(25)
    end

    context "when a resource has no bookings (nil count)" do
      let!(:new_venue) { Venue.create!(name: "Empty Lab", location: location, number_of_past_booking: nil) }

      it "defaults the usage_count to 0" do
        empty_lab = data[:venues].find { |v| v[:name] == "Empty Lab" }
        expect(empty_lab[:usage_count]).to eq(0)
      end
    end

    context "when no tenant is provided" do
      subject { DashboardStatsService.new(nil) }

      it "returns all equipment but uses the default scope logic" do
        # Based on your service: equipments_scope = @tenant.present? ? ... : Equipment.all
        expect(data[:equipments].count).to eq(Equipment.count)
      end
    end
  end
end