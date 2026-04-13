require 'rails_helper'

RSpec.describe BookingsController,  type: :controller do

    #build temporary test data
    let(:user)  {User.create!(email: "test@test.com", name: "Test", role: "student",  password: "123456",  password_confirmation: "123456")}
    let(:venue) {Venue.create!(name: "Test Venue", location: Location.create!(name: "Test Location",  latitude: 0, longitude: 0))}
    let(:time_slot) {TimeSlot.create!(start_time: "09:00", end_time: "10:00")}
    let(:equipment) {Equipment.create!(name:"Test equipment", total_count: 1, available_count: 1)}

    #return test user
    before do
        allow(controller).to receive(:current_user).and_return(user)
    end

    #test submit action
    describe "POST create" do
        it "creates a venue booking" do
            expect{
                post :create, params:{
                    booking:{
                    bookable_id: venue.id, bookable_type: "Venue",  time_slot_id: time_slot.id
                    }
                }
            }.to change(Booking, :count).by(1)
        end

        it "creates an equipent booking" do
            expect{
                post :create, params:{
                    booking:{
                        bookable_id: equipment.id, bookable_type: "Equipment",  time_slot_id: time_slot.id

                    }
                }
            }.to change(Booking, :count).by(1) #expect booked number +1
        end
    end
end