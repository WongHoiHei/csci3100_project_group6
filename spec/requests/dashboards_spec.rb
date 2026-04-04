require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  describe 'GET /dashboards' do
    it 'returns usage_rate and bookings_data JSON' do
      get dashboards_index_path, as: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include(
        'usage_rate' => 75.0,
        'bookings_data' => hash_including('2026-04-01' => 2)
      )
    end
  end
end