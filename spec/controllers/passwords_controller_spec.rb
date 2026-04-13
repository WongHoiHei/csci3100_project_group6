require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let(:errors_double) { double('errors', full_messages: ['Password is invalid']) }
  let(:user) { instance_double(User, id: 42, errors: errors_double) }

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #edit' do
    it 'renders the edit page and hides header' do
      get :edit

      expect(response).to have_http_status(:success)
      expect(assigns(:hide_header)).to eq(true)
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        password_current: 'oldpass',
        password: 'newpass123',
        password_confirmation: 'newpass123'
      }
    end

    it 'updates password, sends mail and redirects when everything succeeds' do
      mail = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      allow(user).to receive(:authenticate).with('oldpass').and_return(true)
      allow(user).to receive(:update).with(password: 'newpass123', password_confirmation: 'newpass123').and_return(true)
      allow(UserMailer).to receive(:password_changed).with(user, 'newpass123').and_return(mail)

      patch :update, params: params

      expect(response).to redirect_to(main_path)
      expect(flash[:notice]).to include('Password changed successfully!')
    end

    it 'shows alert and still redirects when mail delivery fails' do
      allow(user).to receive(:authenticate).with('oldpass').and_return(true)
      allow(user).to receive(:update).with(password: 'newpass123', password_confirmation: 'newpass123').and_return(true)
      allow(UserMailer).to receive_message_chain(:password_changed, :deliver_now).and_raise(StandardError.new('mail fail'))

      patch :update, params: params

      expect(response).to redirect_to(main_path)
      expect(flash[:alert]).to include('confirmation email failed')
    end

    it 're-renders edit when password update fails' do
      allow(user).to receive(:authenticate).with('oldpass').and_return(true)
      allow(user).to receive(:update).with(password: 'newpass123', password_confirmation: 'newpass123').and_return(false)

      patch :update, params: params

      expect(response).to render_template(:edit)
      expect(flash[:alert]).to eq('Password is invalid')
    end

    it 're-renders edit when current password is wrong' do
      allow(user).to receive(:authenticate).with('oldpass').and_return(false)

      patch :update, params: params

      expect(response).to render_template(:edit)
      expect(flash[:alert]).to eq('Current password is incorrect')
    end
  end
end
