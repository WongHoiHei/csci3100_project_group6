require 'rails_helper'

RSpec.describe DashboardStatsService do
  subject(:service) { described_class.new(department) }

  let(:department) { double('Department') }
  let(:bookings_double) { double('bookings') }

  before do
    allow(department).to receive(:bookings).and_return(bookings_double)
  end

  describe '#usage_rate' do
    let(:approved_double) { double('approved', count: 3) }

    before do
      allow(bookings_double).to receive(:approved).and_return(approved_double)
    end

    it 'returns 75.0 for 3/4 booked slots' do
      expect(service.usage_rate).to eq(75.0)
    end
  end

  describe '#bookings_by_date' do
    let(:where_double) { double('where_result') }
    let(:group_double) { double('group_result', count: { '2026-04-01' => 2, '2026-04-02' => 1 }) }

    before do
      allow(bookings_double).to receive(:where).with(anything).and_return(where_double)
      allow(where_double).to receive(:group).with(:start_time).and_return(group_double)
    end

    it 'returns date-count hash for Chart.js' do
      result = service.bookings_by_date(1.day.ago, Time.current)
      expect(result).to eq({ '2026-04-01' => 2, '2026-04-02' => 1 })
    end
  end
end