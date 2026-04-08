Given('I am on the welcome page') do
  visit root_path
end

Given('I am on main page') do
  visit main_path
end

When('I go to login page') do
  click_link 'Login'  
end

When('I navigate to venue booking') do
  visit main_path
  click_link 'Venue Booking'
end

Then('I see venue details') do
  expect(page).to have_content('Room A')
  expect(page).to have_content('Period 1')
end

When('I continue to confirmation') do
  click_link 'Continue'
end

When('I finalize booking') do

  expect(page).to have_css('#confirm_checkbox')
  expect(page).to have_css('#confirm-btn[style*="pointer-events: none"]')
  

  visit booking_final_path
end

Then('booking is successful') do
  expect(page).to have_current_path(booking_final_path, wait: 3)
  expect(page).to have_text('Your booking has been confirmed.')
end

When('I search for {string}') do |query|
  fill_in 'q', with: query
  click_button 'Search'
end

Then('I see projector results') do
  expect(page).to have_content('projector')
  expect(page).to have_content('Projector A')
end