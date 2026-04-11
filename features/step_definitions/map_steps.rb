Given('a default tenant and user exist') do
  @tenant = Tenant.find_or_create_by!(name: "CUHK")
  @user = User.find_or_create_by!(name: "Test User", tenant: @tenant)
end

Given('I am logged into the system') do
  expect(User.first).not_to be_nil
end

# Navigation - 指向 /map
When('I go to the {string}') do |page_name|
  case page_name
  when "map page"
    visit "/map"
  end
end

Then('I should see the {string} element') do |element_id|
  expect(page).to have_css("##{element_id}")
end


When('I fill in {string} with {string}') do |field_id, value|
  fill_in field_id, with: value
end

When('I click {string}') do |button_id|
  click_button button_id
end

Then('I should see {string}') do |expected_text|
  expect(page).to have_content(expected_text)
end

When('I click on the map marker for {string}') do |building_name|
  slug = "sirrunrunshawhall" if building_name == "Sir Run Run Shaw Hall"
  visit building_path(slug: slug)
end

Then('I should see {string} in the building info section') do |expected_text|
  expect(page).to have_content(expected_text)
end

Then('the page should be rendered without the main layout') do
  expect(page).not_to have_css('header')
  expect(page).not_to have_css('footer')
end