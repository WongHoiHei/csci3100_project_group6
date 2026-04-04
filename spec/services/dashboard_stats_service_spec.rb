require 'rails_helper'

RSpec.describe DashboardStatsService, type: :service do
  describe '#usage_rate' do
    it 'calculates percentage of booked time slots for department' do
      dept = create(:department)  # Fails until model/factory exists
      create_list(:booking, 3, department: dept, status: :approved)
      service = described_class.new(dept)
      expect(service.usage_rate).to eq(75.0)  # Assume 4 slots total
    end
  end
end