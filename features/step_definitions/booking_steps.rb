Given('I am on the welcome page') do
  visit root_path
end

Given('I am on main page') do
  visit main_path
end

When('I go to login page') do
  click_link 'Go to Login'
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
  click_link 'Final Confirm'
end

Then('booking is successful') do
  expect(page).to have_content('Booking Successful')
end

When('I search for {string}') do |query|
  fill_in 'q', with: query
  click_button 'Search'
end

Then('I see projector results') do
  expect(page).to have_content('projector')
  expect(page).to have_content('Projector A')
end