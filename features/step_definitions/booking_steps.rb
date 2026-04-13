# features/step_definitions/booking_steps.rb

Given('I am on the welcome page') do
  # Create and log in user first
  @user = User.first || User.create!(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
  visit root_path
end

When('I go to login page') do
  visit login_path
end

When('I navigate to venue booking') do
  @tenant   = Tenant.first || Tenant.create!(name: 'Default Tenant')
  @user     = User.first
  @location = Location.create!(name: 'Sir Run Run Shaw Hall', latitude: 22.4198, longitude: 114.2068)
  @venue    = Venue.create!(name: 'Lecture Theatre', capacity: 100, location: @location)
  @slot     = TimeSlot.create!(start_time: Time.zone.parse('09:00'), end_time: Time.zone.parse('11:00'))

  slug = 'sirrunrunshawhall'
  visit "/buildings/#{slug}"
end

Then('I see venue details') do
  expect(page).to have_content('Venue Booking')
  expect(page).to have_content('Sir Run Run Shaw Hall')
  expect(page).to have_content(@venue.name)
end

When('I continue to confirmation') do
  click_link 'Book →'
end

When('I finalize booking') do
  page.driver.post '/bookings', {
    booking: {
      bookable_id: @venue.id,
      bookable_type: 'Venue',
      time_slot_id: @slot.id,
      booking_date: Date.current.to_s
    }
  }
  visit bookings_path  # follow the redirect manually
end
Then('booking is successful') do
  expect(page).to have_content('Booking request submitted')
end


Given('I am on main page') do
  @user = User.first || User.create!(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
  visit map_path
end

When('I search for {string}') do |query|
  fill_in 'venue-search', with: query
  click_button 'Search'
end

Then('I see projector results') do
   expect(page).to have_field('venue-search', with: 'projector')
end