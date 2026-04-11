require 'rails_helper'

RSpec.describe BuildingsController, type: :controller do
  describe "GET #show" do
    context "with a valid slug" do
      it "correctly maps to Sir Run Run Shaw Hall" do
        get :show, params: { slug: 'sirrunrunshawhall' }
        expect(assigns(:official_name)).to eq("Sir Run Run Shaw Hall")
        expect(response).to have_http_status(:success)
      end

      it "correctly maps to New Asia College Gymnasium" do
        get :show, params: { slug: 'nagym' }
        expect(assigns(:official_name)).to eq("New Asia College Gymnasium")
      end
    end

    context "with an invalid slug" do
      it "returns Unknown Building" do
        get :show, params: { slug: 'invalid-building' }
        expect(assigns(:official_name)).to eq("Unknown Building")
      end
    end

    it "renders without the default layout" do
      get :show, params: { slug: 'nagym' }
      expect(response).to render_template(layout: false)
    end
  end
end