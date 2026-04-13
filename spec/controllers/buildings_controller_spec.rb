require 'rails_helper'

RSpec.describe BuildingsController, type: :controller do
  let(:shaw_hall) do
    instance_double('Location',
      name: 'Sir Run Run Shaw Hall',
      venues: double('venues', order: [])
    )
  end

  let(:na_gym) do
    instance_double('Location',
      name: 'New Asia College Gymnasium',
      venues: double('venues', order: [])
    )
  end

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(
      instance_double('User', id: 1, name: 'Test User')
    )
    allow(Location).to receive(:all).and_return([shaw_hall, na_gym])
    allow(Booking).to receive_message_chain(:where, :where, :where, :not, :pluck).and_return([])
  end

  describe "GET #show" do
    context "with a valid slug" do
      it "correctly maps to Sir Run Run Shaw Hall" do
        get :show, params: { slug: 'sirrunrunshawhall' }
        expect(assigns(:official_name)).to eq("Sir Run Run Shaw Hall")
        expect(response).to have_http_status(:success)
      end

      it "correctly maps to New Asia College Gymnasium" do
        get :show, params: { slug: 'newasiacollegegymnasium' }
        expect(assigns(:official_name)).to eq("New Asia College Gymnasium")
      end
    end

    context "with an invalid slug" do
      it "redirects to map with an alert" do
        get :show, params: { slug: 'invalid-building' }
        expect(response).to redirect_to(map_path)
        expect(flash[:alert]).to eq("Location not found.")
      end
    end

    it "renders without the default layout" do
      get :show, params: { slug: 'newasiacollegegymnasium' }
      expect(response).to render_template(layout: false)
    end
  end
end