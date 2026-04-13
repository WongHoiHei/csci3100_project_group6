require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:early_slot) { TimeSlot.create!(start_time: '08:00', end_time: '09:00') }
  let!(:late_slot)  { TimeSlot.create!(start_time: '10:00', end_time: '11:00') }
  let!(:location)   { Location.create!(name: 'Search Campus') }
  let!(:venue)      { Venue.create!(name: 'Robotics Lab', location: location) }
  let!(:equipment)  { Equipment.create!(name: 'Projector', total_count: 2, available_count: 2) }

  before do
    allow(controller).to receive(:require_login).and_return(true)
  end

  describe 'GET #index' do
    it 'returns matching equipment and venues when query is present' do
      get :index, params: { q: 'pro' }

      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq('pro')
      expect(assigns(:time_slots)).to eq([early_slot, late_slot])
      expect(assigns(:equipment_results)).to eq([equipment])
      expect(assigns(:venue_results)).to eq([])
    end

    it 'returns empty results when query is blank' do
      get :index

      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to be_nil
      expect(assigns(:equipment_results)).to eq([])
      expect(assigns(:venue_results)).to eq([])
    end
  end
end
