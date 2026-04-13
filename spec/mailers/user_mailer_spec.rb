require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) do
    User.create!(
      name: 'Password User',
      email: 'password.user@example.com',
      password: 'oldpassword',
      password_confirmation: 'oldpassword'
    )
  end

  let(:new_password) { 'newpassword123' }

  describe '#password_changed' do
    subject(:mail) { described_class.password_changed(user, new_password) }

    it 'builds a password changed email with both html and text content' do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ApplicationMailer.default[:from]])
      expect(mail.subject).to eq('Your password has been changed')
      expect(mail.html_part.body.encoded).to include('Password Changed')
      expect(mail.html_part.body.encoded).to include(user.name)
      expect(mail.html_part.body.encoded).to include(new_password)
      expect(mail.text_part.body.encoded).to include('Password Changed')
      expect(mail.text_part.body.encoded).to include(user.name)
      expect(mail.text_part.body.encoded).to include(new_password)
    end
  end
end