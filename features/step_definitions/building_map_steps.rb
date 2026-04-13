When('I go to the {string}') do |page_name|
  case page_name
  when 'map page'
    visit map_path
  else
    raise "Unknown page: #{page_name}"
  end
end

Then('I should see the {string} element') do |element_id|
  expect(page).to have_css("##{element_id}")
end

When('I click on the map marker for {string}') do |building_name|
  Location.find_or_create_by!(name: building_name) do |loc|
    loc.latitude  = 22.4198
    loc.longitude = 114.2068
  end

  slug = building_name.downcase.gsub(/[^a-z0-9]+/, '')
  visit "/buildings/#{slug}"
end

Then('I should see {string} in the building info section') do |text|
  expect(page).to have_content(text)
end

Then('the page should be rendered without the main layout') do
  expect(page).not_to have_css('nav')       
  expect(page).not_to have_css('#main-nav')  
end

Given('a default tenant and user exist') do
  @tenant = Tenant.first || Tenant.create!(name: 'Default Tenant')
  @user = User.first || User.create!(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password',
    password_confirmation: 'password'  # ← add this
  )
end

Given('I am logged into the system') do
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end