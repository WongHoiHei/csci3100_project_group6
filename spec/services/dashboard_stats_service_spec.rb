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

  let!(:venue_a) { Venue.create!(name: "Lab A", location: location) }
  let!(:venue_b) { Venue.create!(name: "Lab B", location: location) }
  let!(:equipment_a) { Equipment.create!(name: "Oscilloscope") }

  let!(:time_slot) do
    TimeSlot.create!(
      start_time: Time.now,
      end_time: 2.hours.from_now
    )
  end

  describe "#resource_usage_data" do
    subject { DashboardStatsService.new.resource_usage_data }

    context "with mixed booking statuses" do
      before do
        # 2 Approved (Should be counted)
        2.times do 
          Booking.create!(bookable: venue_a, user: user, time_slot: time_slot, status: "approved", start_time: Time.now, end_time: 1.hour.from_now)
        end

        # 1 Rejected (Should not be counted)
        Booking.create!(bookable: venue_a, user: user, time_slot: time_slot, status: "rejected", start_time: Time.now, end_time: 1.hour.from_now)

        # 1 Pending (Should be counted)
        Booking.create!(bookable: equipment_a, user: user, time_slot: time_slot, status: "pending", start_time: Time.now, end_time: 1.hour.from_now)
      end

      it "counts only non-rejected bookings for venues" do
        venue_data = subject[:venues].find { |v| v[:name] == "Lab A" }
        expect(venue_data[:usage_count]).to eq(2)
      end

      it "counts pending and approved bookings for equipment" do
        equip_data = subject[:equipments].find { |e| e[:name] == "Oscilloscope" }
        expect(equip_data[:usage_count]).to eq(1)
      end

      it "returns 0 for resources with no bookings (Lab B)" do
        venue_data = subject[:venues].find { |v| v[:name] == "Lab B" }
        expect(venue_data[:usage_count]).to eq(0)
      end
    end

    context "sorting and structure" do
      it "returns a hash with correct keys" do
        expect(subject).to have_key(:venues)
        expect(subject).to have_key(:equipments)
      end

      it "orders venues by name alphabetically" do
        Venue.create!(name: "C-Lab", location: location)
        venue_names = subject[:venues].map { |v| v[:name] }
        expect(venue_names).to eq(venue_names.sort)
      end
    end

    context "when the database is empty" do
      before do
        Booking.delete_all
        TimeSlot.delete_all
        
        Venue.delete_all
        Equipment.delete_all
        Location.delete_all
        Tenant.delete_all
      end

      it "returns empty arrays for :venues and :equipments" do
        expect(subject[:venues]).to be_empty
        expect(subject[:equipments]).to be_empty
      end
    end
  end
end