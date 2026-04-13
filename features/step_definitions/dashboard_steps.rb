Given("a location exists named {string}") do |name|
  @location = Location.create!(name: name)
end

Given("a venue exists named {string} in {string}") do |venue_name, location_name|
  @resources ||= {}
  loc = Location.find_by(name: location_name)
  @resources[venue_name] = Venue.create!(name: venue_name, location: loc)
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
  @time_slot = TimeSlot.create!(
    start_time: DateTime.parse(start_t),
    end_time: DateTime.parse(end_t)
  )
end

Given("an equipment exists named {string} for tenant {string}") do |equip_name, _tenant_name|
  @resources ||= {}
  @resources[equip_name] = Equipment.create!(
    name: equip_name, 
    total_count: 1, 
    available_count: 1
  )
end

Given("a booking exists for {string} with status {string}") do |resource_name, status|
  @resources ||= {}
  resource = @resources[resource_name] || Venue.find_by(name: resource_name) || Equipment.find_by(name: resource_name)
  
  raise "Could not find resource: #{resource_name}" if resource.nil?

  Booking.create!(
    bookable: resource,           # 指向 Venue 或 Equipment
    user: @user,
    time_slot: @time_slot || TimeSlot.last, # 關聯到獨立的 TimeSlot
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
