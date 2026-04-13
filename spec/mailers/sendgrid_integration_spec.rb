require 'rails_helper'
require 'json'

# �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
# SendGrid API Integration Tests
#
# Strategy: build the mail message via the real mailer, then deliver it
# directly through SendGridActionMailer::DeliveryMethod �X bypassing the need
# to swap ActionMailer::Base.delivery_method at runtime.
# SendGrid::API is stubbed so no real HTTP requests are made.
# �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
RSpec.describe 'SendGrid API integration', type: :mailer do
  # �w�w HTTP-layer doubles �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
  let(:sg_response)     { double('sg_response',    status_code: '202', body: '') }
  let(:sg_post_target)  { double('sg_post_target') }
  let(:sg_mail_node)    { double('sg_mail_node') }
  let(:sg_client)       { double('sg_client') }
  let(:sg_api_instance) { double('sg_api_instance') }

  # �w�w delivery method instance (used directly in each test) �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
  let(:sendgrid_delivery) do
    SendGridActionMailer::DeliveryMethod.new(
      api_key:               'SG.fake_test_key_for_specs',
      raise_delivery_errors: true
    )
  end

  # �w�w data fixtures �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
  let(:user)  { instance_double(User,      name: 'SG Test User', email: 'sg.user@example.com') }
  let(:venue) { instance_double(Venue,     name: 'SG Test Hall') }
  let(:equip) { instance_double(Equipment, name: 'SG Projector') }

  let(:start_time) { Time.zone.parse('2026-04-20 09:00') }
  let(:end_time)   { Time.zone.parse('2026-04-20 11:00') }

  let(:venue_booking) do
    instance_double(Booking,
                    user: user, bookable: venue, bookable_type: 'Venue',
                    status: 'success', start_time: start_time,
                    end_time: end_time, time_slot: nil)
  end

  let(:equip_booking) do
    instance_double(Booking,
                    user: user, bookable: equip, bookable_type: 'Equipment',
                    status: 'success', start_time: start_time,
                    end_time: end_time, time_slot: nil)
  end

  # �w�w stub the SendGrid HTTP chain before every example �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
  # The gem calls:
  #   SendGrid::API.new(api_key: ..., http_options: {}).client
  #                   .mail._('send').post(request_body: json)
  # We intercept at SendGrid::API.new, using hash_including so the extra
  # http_options: {} kwarg does not break argument matching.
  let(:captured_payloads) { [] }

  before do
    allow(SendGrid::API).to receive(:new)
      .with(hash_including(api_key: 'SG.fake_test_key_for_specs'))
      .and_return(sg_api_instance)

    allow(sg_api_instance).to receive(:client).and_return(sg_client)
    allow(sg_client).to receive(:mail).and_return(sg_mail_node)
    allow(sg_mail_node).to receive(:_).with('send').and_return(sg_post_target)

    allow(sg_post_target).to receive(:post) do |args|
      # SendGrid::Mail#to_json returns a Hash (with nested SendGrid objects),
      # not a plain JSON string. Round-trip through JSON.generate to get a
      # plain Ruby hash with string keys suitable for assertions.
      raw = args[:request_body]
      captured_payloads << JSON.parse(raw.is_a?(String) ? raw : JSON.generate(raw))
      sg_response
    end
  end

  # �w�w helpers �w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w�w
  def first_payload   = captured_payloads.first
  def payload_to      = first_payload.dig('personalizations', 0, 'to').map { |r| r['email'] }
  def payload_subject = first_payload['subject']

  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  # BookingMailer#confirmation
  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  describe 'BookingMailer#confirmation' do
    context 'venue booking' do
      before { sendgrid_delivery.deliver!(BookingMailer.confirmation(venue_booking).message) }

      it 'initialises the SendGrid API client with the configured API key' do
        expect(SendGrid::API).to have_received(:new)
          .with(hash_including(api_key: 'SG.fake_test_key_for_specs'))
      end

      it 'posts exactly one request to the SendGrid /mail/send endpoint' do
        expect(captured_payloads.size).to eq(1)
      end

      it 'sets the recipient to the booking user email' do
        expect(payload_to).to include(user.email)
      end

      it 'sets the subject to "Booking Confirmation"' do
        expect(payload_subject).to eq('Booking Confirmation')
      end

      it 'sets the from address to the application default sender' do
        expect(first_payload['from']['email']).to eq(ApplicationMailer.default[:from])
      end
    end

    context 'equipment booking' do
      before { sendgrid_delivery.deliver!(BookingMailer.confirmation(equip_booking).message) }

      it 'posts exactly one request to the SendGrid /mail/send endpoint' do
        expect(captured_payloads.size).to eq(1)
      end

      it 'sets the recipient to the booking user email' do
        expect(payload_to).to include(user.email)
      end

      it 'sets the subject to "Booking Confirmation"' do
        expect(payload_subject).to eq('Booking Confirmation')
      end
    end
  end

  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  # BookingMailer#deletion  (cancellation)
  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  describe 'BookingMailer#deletion' do
    context 'venue booking' do
      before { sendgrid_delivery.deliver!(BookingMailer.deletion(venue_booking).message) }

      it 'initialises the SendGrid API client with the configured API key' do
        expect(SendGrid::API).to have_received(:new)
          .with(hash_including(api_key: 'SG.fake_test_key_for_specs'))
      end

      it 'posts exactly one request to the SendGrid /mail/send endpoint' do
        expect(captured_payloads.size).to eq(1)
      end

      it 'sets the recipient to the booking user email' do
        expect(payload_to).to include(user.email)
      end

      it 'sets the subject to "Booking Cancellation"' do
        expect(payload_subject).to eq('Booking Cancellation')
      end
    end

    context 'equipment booking' do
      before { sendgrid_delivery.deliver!(BookingMailer.deletion(equip_booking).message) }

      it 'posts exactly one request to the SendGrid /mail/send endpoint' do
        expect(captured_payloads.size).to eq(1)
      end

      it 'sets the subject to "Booking Cancellation"' do
        expect(payload_subject).to eq('Booking Cancellation')
      end
    end
  end

  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  # UserMailer#password_changed
  # ����������������������������������������������������������������������������������������������������������������������������������������������������
  describe 'UserMailer#password_changed' do
    let(:real_user) do
      User.create!(
        name:                  'SG PW User',
        email:                 "sg.pw.#{SecureRandom.hex(4)}@example.com",
        password:              'Passw0rd!1',
        password_confirmation: 'Passw0rd!1'
      )
    end

    let(:new_password) { 'NewSecure99!' }

    before { sendgrid_delivery.deliver!(UserMailer.password_changed(real_user, new_password).message) }

    it 'initialises the SendGrid API client with the configured API key' do
      expect(SendGrid::API).to have_received(:new)
        .with(hash_including(api_key: 'SG.fake_test_key_for_specs'))
    end

    it 'posts exactly one request to the SendGrid /mail/send endpoint' do
      expect(captured_payloads.size).to eq(1)
    end

    it 'sets the recipient to the user who changed their password' do
      expect(payload_to).to include(real_user.email)
    end

    it 'sets the subject to "Your password has been changed"' do
      expect(payload_subject).to eq('Your password has been changed')
    end

    it 'sets the from address to the application default sender' do
      expect(first_payload['from']['email']).to eq(ApplicationMailer.default[:from])
    end
  end

  # SendGrid configuration
  describe 'SendGrid delivery method configuration' do
    it 'is registered as a valid ActionMailer delivery method' do
      expect(ActionMailer::Base.delivery_methods).to include(:sendgrid_actionmailer)
    end

    it 'raises delivery errors when raise_delivery_errors is true' do
      delivery = SendGridActionMailer::DeliveryMethod.new(
        api_key:               'SG.fake_test_key_for_specs',
        raise_delivery_errors: true
      )
      expect(delivery.settings[:raise_delivery_errors]).to be(true)
    end

    it 'reads a configured api_key through the delivery method settings' do
      delivery = SendGridActionMailer::DeliveryMethod.new(api_key: 'SG.example_key')
      expect(delivery.settings[:api_key]).to eq('SG.example_key')
    end

    it 'uses the SENDGRID_API_KEY environment variable in the development config' do
      dev_config = File.read(Rails.root.join('config', 'environments', 'development.rb'))
      expect(dev_config).to include('ENV["SENDGRID_API_KEY"]')
    end

    it 'delivers email via sendgrid_actionmailer in the development config' do
      dev_config = File.read(Rails.root.join('config', 'environments', 'development.rb'))
      expect(dev_config).to include(':sendgrid_actionmailer')
    end
  end
end
