require 'rails_helper'

RSpec.feature 'Booking Flow', type: :feature do
  scenario 'complete venue booking flow' do
    visit root_path
    click_link 'Go to Login'
    
    visit main_path
    click_link 'Venue Booking'
    expect(page).to have_content('Venue Booking')
    
    click_link 'Continue'
    expect(page).to have_content('Confirmation')
    
    visit booking_final_path 
    expect(page).to have_content('Booking Successful')
  end

  scenario 'complete equipment booking flow' do
    visit main_path
    click_link 'Equipment Booking'
    expect(page).to have_content('Projector')
    
    click_link 'Continue'
    expect(page).to have_content('Confirmation')
    
    visit booking_final_path  
    expect(page).to have_content('Booking Successful')  
  end

  scenario 'search works' do
    visit main_path
    fill_in 'q', with: 'projector'
    click_button 'Search'
    expect(page).to have_content('projector')
    expect(page).to have_content('Projector A')
  end
end