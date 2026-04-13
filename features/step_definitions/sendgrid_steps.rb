require 'securerandom'
require 'json'

module SendGridCucumberHelpers
  # Wire up all stubs and accumulate posted payloads into @sg_payloads.
  def setup_sendgrid_mock!
    @sg_payloads = []

    @sg_response    = double('sg_response',    status_code: '202', body: '')
    @sg_post_target = double('sg_post_target')
    @sg_mail_node   = double('sg_mail_node')
    @sg_client      = double('sg_client')
    @sg_api         = double('sg_api')

    allow(@sg_post_target).to receive(:post) do |args|
      raw = args[:request_body]
      @sg_payloads << JSON.parse(raw.is_a?(String) ? raw : JSON.generate(raw))
      @sg_response
    end

    allow(@sg_mail_node).to receive(:_).with('send').and_return(@sg_post_target)
    allow(@sg_client).to receive(:mail).and_return(@sg_mail_node)
    allow(@sg_api).to receive(:client).and_return(@sg_client)
    allow(SendGrid::API).to receive(:new).and_return(@sg_api)
  end

  # Switch ActionMailer to use the real sendgrid_actionmailer delivery path
  # (still mocked at the HTTP level) and remember the original method so we
  # can restore it afterwards.
  def enable_sendgrid_delivery!
    @_orig_delivery_method   = ActionMailer::Base.delivery_method
    @_orig_sendgrid_settings =
      ActionMailer::Base.respond_to?(:sendgrid_actionmailer_settings) &&
      ActionMailer::Base.sendgrid_actionmailer_settings
    @_orig_booking_delivery_method = BookingMailer.delivery_method
    @_orig_user_delivery_method = UserMailer.delivery_method

    ActionMailer::Base.delivery_method = :sendgrid_actionmailer
    ActionMailer::Base.sendgrid_actionmailer_settings = {
      api_key: 'SG.cucumber_fake_key',
      raise_delivery_errors: true
    }
    BookingMailer.delivery_method = :sendgrid_actionmailer
    UserMailer.delivery_method = :sendgrid_actionmailer
  end

  def restore_original_delivery!
    ActionMailer::Base.delivery_method = @_orig_delivery_method
    if @_orig_sendgrid_settings
      ActionMailer::Base.sendgrid_actionmailer_settings = @_orig_sendgrid_settings
    end
    BookingMailer.delivery_method = @_orig_booking_delivery_method if defined?(@_orig_booking_delivery_method)
    UserMailer.delivery_method = @_orig_user_delivery_method if defined?(@_orig_user_delivery_method)
  end

  # Return the last captured payload hash for assertion helpers.
  def last_sg_payload
    @sg_payloads.last
  end
end

World(SendGridCucumberHelpers)

# Restore original delivery method after every sendgrid scenario.
After do
  restore_original_delivery! if @_orig_delivery_method
end

# ─────────────────────────────────────────────────────────────────────────────
# Background step
# ─────────────────────────────────────────────────────────────────────────────

Given('the SendGrid API client is mocked for cucumber') do
  enable_sendgrid_delivery!
  setup_sendgrid_mock!
end

# ─────────────────────────────────────────────────────────────────────────────
# Authentication
# ─────────────────────────────────────────────────────────────────────────────

Given('I am logged in as a sendgrid cucumber test user') do
  token = SecureRandom.hex(4)
  @sg_user = User.create!(
    name:                  'SG Cucumber User',
    email:                 "sg-cucumber-#{token}@example.com",
    password:              'Passw0rd!1',
    password_confirmation: 'Passw0rd!1'
  )

  visit login_path
  fill_in 'Email',    with: @sg_user.email
  fill_in 'Password', with: 'Passw0rd!1'
  click_button 'Log in'
end

# ─────────────────────────────────────────────────────────────────────────────
# Data setup – venue
# ─────────────────────────────────────────────────────────────────────────────

Given('a venue and time slot exist for sendgrid cucumber testing') do
  location     = Location.create!(name: "SG Hall #{SecureRandom.hex(3)}",
                                  latitude: 22.3, longitude: 114.2)
  @sg_venue     = Venue.create!(name: 'SG Cucumber Venue', location: location)
  @sg_time_slot = TimeSlot.create!(
    venue:      @sg_venue,
    start_time: Time.zone.parse('09:00'),
    end_time:   Time.zone.parse('11:00')
  )
  @sg_booking_date = Date.new(2026, 4, 25)
  @sg_bookable     = @sg_venue
  @sg_bookable_type = 'Venue'
end

# ─────────────────────────────────────────────────────────────────────────────
# Data setup – equipment
# ─────────────────────────────────────────────────────────────────────────────

Given('equipment and a time slot exist for sendgrid cucumber testing') do
  location      = Location.create!(name: "SG Equip Hall #{SecureRandom.hex(3)}",
                                   latitude: 22.3, longitude: 114.2)
  support_venue = Venue.create!(name: 'SG Equip Support Venue', location: location)
  tenant        = Tenant.create!(name: "SG Tenant #{SecureRandom.hex(3)}")
  @sg_equipment = Equipment.create!(
    name:            'SG Cucumber Projector',
    tenant:          tenant,
    total_count:     3,
    available_count: 3
  )
  @sg_time_slot = TimeSlot.create!(
    venue:      support_venue,
    start_time: Time.zone.parse('09:00'),
    end_time:   Time.zone.parse('11:00')
  )
  @sg_booking_date  = Date.new(2026, 4, 25)
  @sg_bookable      = @sg_equipment
  @sg_bookable_type = 'Equipment'
end

# ─────────────────────────────────────────────────────────────────────────────
# Data setup – existing booking (for cancellation)
# ─────────────────────────────────────────────────────────────────────────────

Given('an existing venue booking is present for sendgrid cucumber testing') do
  step 'a venue and time slot exist for sendgrid cucumber testing'

  @sg_existing_booking = Booking.create!(
    user:       @sg_user,
    bookable:   @sg_bookable,
    time_slot:  @sg_time_slot,
    status:     'success',
    start_time: Time.zone.parse('2026-04-25 09:00'),
    end_time:   Time.zone.parse('2026-04-25 11:00')
  )

  # Clear any confirmation email that may have been captured during setup
  @sg_payloads.clear
end

# ─────────────────────────────────────────────────────────────────────────────
# Action steps
# ─────────────────────────────────────────────────────────────────────────────

When('I submit a booking for the sendgrid cucumber venue') do
  page.driver.post '/bookings', {
    booking: {
      bookable_id:   @sg_bookable.id,
      bookable_type: @sg_bookable_type,
      time_slot_id:  @sg_time_slot.id,
      booking_date:  @sg_booking_date.to_s
    }
  }
end

When('I submit a booking for the sendgrid cucumber equipment') do
  # Re-use the shared bookable set up by the equipment Given step
  page.driver.post '/bookings', {
    booking: {
      bookable_id:   @sg_bookable.id,
      bookable_type: @sg_bookable_type,
      time_slot_id:  @sg_time_slot.id,
      booking_date:  @sg_booking_date.to_s
    }
  }
end

When('I cancel the sendgrid cucumber booking') do
  page.driver.delete "/bookings/#{@sg_existing_booking.id}"
end

When('I change my password via the sendgrid cucumber password form') do
  visit password_edit_path
  fill_in 'Current Password',     with: 'Passw0rd!1'
  fill_in 'New Password',          with: 'NewCucumber99!'
  fill_in 'Confirm New Password',  with: 'NewCucumber99!'
  click_button 'Update Password'
end

# ─────────────────────────────────────────────────────────────────────────────
# Assertion steps
# ─────────────────────────────────────────────────────────────────────────────

Then('the SendGrid API should have received exactly {int} send request(s)') do |count|
  expect(@sg_payloads.size).to eq(count)
end

Then('the sendgrid payload should be addressed to the logged-in user') do
  recipients = last_sg_payload.dig('personalizations', 0, 'to').map { |r| r['email'] }
  expect(recipients).to include(@sg_user.email)
end

Then('the sendgrid payload subject should equal {string}') do |expected_subject|
  expect(last_sg_payload['subject']).to eq(expected_subject)
end
