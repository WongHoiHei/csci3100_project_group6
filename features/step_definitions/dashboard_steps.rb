Given("a tenant exists named {string}") do |name|
  @tenant = Tenant.create!(name: name)
end

Given("a location exists named {string}") do |name|
  @location = Location.create!(name: name)
end

Given("a venue exists named {string} in {string}") do |venue_name, location_name|
  loc = Location.find_by(name: location_name)
  Venue.create!(name: venue_name, location: loc)
end

Given("an equipment exists named {string} for tenant {string}") do |equip_name, tenant_name|
  t = Tenant.find_by(name: tenant_name)
  Equipment.create!(name: equip_name, tenant: t)
end

Given("I am logged in as a {string}") do |name|
  @user = User.create!(
    name: name,
    email: "test@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  visit "/login"
  fill_in "email", with: @user.email
  fill_in "password", with: "password123"
  click_button "Log in"
end

# --- Booking Steps ---

Given("a time slot exists for {string} from {string} to {string}") do |venue_name, start_t, end_t|
  venue = Venue.find_by(name: venue_name)
  @time_slot = TimeSlot.create!(
    venue: venue,
    start_time: DateTime.parse(start_t),
    end_time: DateTime.parse(end_t)
  )
end

Given("a booking exists for {string} with status {string}") do |resource_name, status|
  resource = Venue.find_by(name: resource_name) || Equipment.find_by(name: resource_name)
  
  Booking.create!(
    bookable: resource,
    user: @user,
    time_slot: @time_slot || TimeSlot.first,
    status: status,
    start_time: Time.now,
    end_time: 1.hour.from_now
  )
end

# --- Navigation & Verification ---

When("I visit the dashboard page") do
  visit dashboards_path
end

Then("I should see {string} usage counts for {string}") do |count, resource_name|
  
  find('tr', text: resource_name, wait: 5).then do |row|
    expect(row).to have_content(count)
  end
end