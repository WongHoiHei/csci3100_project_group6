require 'rails_helper'

RSpec.describe DashboardStatsService do
  subject(:service) { described_class.new(department) }

  let(:department) { double('Department') }
  let(:bookings_double) { double('bookings') }
  let(:approved_double) { double('approved_scope', count: 3) }

  before do
    allow(department).to receive(:bookings).and_return(bookings_double)
    allow(bookings_double).to receive(:approved).and_return(approved_double)
  end

  describe '#usage_rate' do
    it 'returns 75.0 for 3/4 booked slots' do
      expect(service.usage_rate).to eq(75.0)
    end
  end
end