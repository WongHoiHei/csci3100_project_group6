require 'securerandom'

def expect_booking_mail_delivery(subject:, recipient:, bookable_name:, bookable_type:)
  expect(ActionMailer::Base.deliveries.size).to eq(1)

  email = ActionMailer::Base.deliveries.last
  expect(email.subject).to eq(subject)
  expect(email.to).to eq([recipient])
  expect(email.body.encoded).to include(bookable_name)
  expect(email.body.encoded).to include(bookable_type)
  expect(email.body.encoded).to include('2026-04-21 09:00')
  expect(email.body.encoded).to include('2026-04-21 11:00')
end

Given('I am logged in as a mailer test user') do
  ActionMailer::Base.deliveries.clear

  unique_token = SecureRandom.hex(4)
  @mailer_test_user = User.create!(
    name: 'Mailer Test User',
    email: "mailer-#{unique_token}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )

  visit login_path
  fill_in 'Email', with: @mailer_test_user.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

When('I change my password through the password form') do
  visit password_edit_path
  fill_in 'Current Password', with: 'password123'
  fill_in 'New Password', with: 'updatedpass123'
  fill_in 'Confirm New Password', with: 'updatedpass123'
  click_button 'Update Password'
end

Then('a password change email should be delivered') do
  expect(ActionMailer::Base.deliveries.size).to eq(1)

  email = ActionMailer::Base.deliveries.last
  expect(email.subject).to eq('Your password has been changed')
  expect(email.to).to eq([@mailer_test_user.email])
  expect(email.html_part.body.encoded).to include('updatedpass123')
end

Given('a venue booking is ready for mailer testing') do
  location_name = "Mailer Hall #{SecureRandom.hex(3)}"
  @location = Location.create!(name: location_name, latitude: 22.3, longitude: 114.2)
  @venue = Venue.create!(name: 'Mailer Venue', location: @location)
  @time_slot = TimeSlot.create!(
    start_time: Time.zone.parse('09:00'),
    end_time: Time.zone.parse('11:00')
  )
  @booking_date = Date.new(2026, 4, 21)
  @mail_bookable = @venue
  @mail_bookable_type = 'Venue'
end

Given('an equipment booking is ready for mailer testing') do
  location_name = "Mailer Equipment Hall #{SecureRandom.hex(3)}"
  @location = Location.create!(name: location_name, latitude: 22.3, longitude: 114.2)
  @venue = Venue.create!(name: 'Equipment Support Venue', location: @location)
  @equipment = Equipment.create!(
    name: 'Mailer Projector',
    total_count: 3,
    available_count: 3
  )
  @time_slot = TimeSlot.create!(
    start_time: Time.zone.parse('09:00'),
    end_time: Time.zone.parse('11:00')
  )
  @booking_date = Date.new(2026, 4, 21)
  @mail_bookable = @equipment
  @mail_bookable_type = 'Equipment'
end

When('I submit the booking request directly') do
  page.driver.post '/bookings', {
    booking: {
      bookable_id: @mail_bookable.id,
      bookable_type: @mail_bookable_type,
      time_slot_id: @time_slot.id,
      booking_date: @booking_date.to_s
    }
  }
end

Then('a venue booking confirmation email should be delivered') do
  expect_booking_mail_delivery(
    subject: 'Booking Confirmation',
    recipient: @mailer_test_user.email,
    bookable_name: @venue.name,
    bookable_type: 'Venue'
  )
end

Then('an equipment booking confirmation email should be delivered') do
  expect_booking_mail_delivery(
    subject: 'Booking Confirmation',
    recipient: @mailer_test_user.email,
    bookable_name: @equipment.name,
    bookable_type: 'Equipment'
  )
end

Given('an existing venue booking is ready for cancellation mailer testing') do
  step 'a venue booking is ready for mailer testing'

  @existing_booking = Booking.create!(
    user: @mailer_test_user,
    bookable: @mail_bookable,
    time_slot: @time_slot,
    status: 'success',
    start_time: Time.zone.parse('2026-04-21 09:00'),
    end_time: Time.zone.parse('2026-04-21 11:00')
  )

  ActionMailer::Base.deliveries.clear
end

Given('an existing equipment booking is ready for cancellation mailer testing') do
  step 'an equipment booking is ready for mailer testing'

  @existing_booking = Booking.create!(
    user: @mailer_test_user,
    bookable: @mail_bookable,
    time_slot: @time_slot,
    status: 'success',
    start_time: Time.zone.parse('2026-04-21 09:00'),
    end_time: Time.zone.parse('2026-04-21 11:00')
  )

  ActionMailer::Base.deliveries.clear
end

When('I cancel the existing booking directly') do
  page.driver.delete "/bookings/#{@existing_booking.id}"
end

Then('a venue booking cancellation email should be delivered') do
  expect_booking_mail_delivery(
    subject: 'Booking Cancellation',
    recipient: @mailer_test_user.email,
    bookable_name: @venue.name,
    bookable_type: 'Venue'
  )
end

Then('an equipment booking cancellation email should be delivered') do
  expect_booking_mail_delivery(
    subject: 'Booking Cancellation',
    recipient: @mailer_test_user.email,
    bookable_name: @equipment.name,
    bookable_type: 'Equipment'
  )
end