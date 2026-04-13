require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new user and hides the header' do
      get :new

      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:hide_header)).to eq(true)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        user: {
          email: 'new-user@example.com',
          name: 'New User',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: 'bad-email',
          name: '',
          password: '123',
          password_confirmation: '999'
        }
      }
    end

    it 'creates the user and redirects to login on success' do
      expect do
        post :create, params: valid_params
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq('Sign up successful! Please log in.')
    end

    it 'renders new with unprocessable entity on failure' do
      expect do
        post :create, params: invalid_params
      end.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to be_present
    end
  end
end
