# --- DATA SETUP ---

Given('the following departments exist:') do |table|
  table.hashes.each do |row|
    Tenant.find_or_create_by!(name: row['name'])
  end
end

Given('{string} has a venue {string} with {int} bookings') do |dept_name, venue_name, count|
  dept = Tenant.find_by!(name: dept_name)
  venue = Venue.create!(name: venue_name, tenant: dept)
  
  # Adjusted to handle standard Rails auth validations
  user = User.find_by(email: "test_user@example.com") || User.create!(
    email: "test_user@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  count.times do
    Booking.create!(
      bookable: venue,
      user: user,
      start_time: Time.current,
      end_time: 1.hour.from_now
    )
  end
end

Given('{string} has equipment {string} with {int} usages') do |dept_name, equip_name, count|
  dept = Tenant.find_by!(name: dept_name)
  equipment = Equipment.create!(name: equip_name, tenant: dept)
  
  count.times do
    # Ensure your Usage model doesn't require a User; if it does, pass the user here
    equipment.usages.create! 
  end
end

# --- NAVIGATION & AUTH ---

Given('I am logged in') do
  @user = User.find_by(email: "admin@example.com") || User.create!(
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  click_button 'Login'
end

Given('I am on the dashboards page') do
  visit dashboards_path
end

# --- ASSERTIONS ---

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should see a chart for {string}') do |chart_type|
  target = "#{chart_type.downcase.chomp('s')}Chart"
  expect(page).to have_css("canvas[data-dashboard-target='#{target}']")
end

Then('the department selector should show {string}') do |expected_dept|
  expect(page).to have_select('tenant_id', selected: expected_dept)
end

When('I select {string} from {string}') do |option, _select_id|
  find("select[name='tenant_id']").select(option)
end

Then('the {string} chart should update to show data for {string}') do |type, dept_name|
  target_list = type == "Venues" ? "venueList" : "equipmentList"
  # Capybara will wait a few seconds for the AJAX/Stimulus update to happen
  within("[data-dashboard-target='#{target_list}']") do
    expect(page).to have_content(dept_name)
  end
end

Then('I should see {string} in the department selector') do |dept_name|
  expect(page).to have_select('tenant_id', selected: dept_name)
end