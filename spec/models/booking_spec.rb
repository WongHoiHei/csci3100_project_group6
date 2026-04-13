require 'rails_helper'



def test_user
    @test_user ||= User.first || User.create!(
        email: "test@gmail.com", name: "test user", role:"student", password:"123456", password_confirmation:"123456"
    )
end

def test_location
    @test_location ||=Location.first ||Location.create!(
        name: "Test Location", latitude: 0, longitude: 0)
end

def test_venue
    @test_venue ||= Venue.first ||Venue.create!(
        name: "test venue", location: test_location
    )
end

def test_time_slot
  @test_time_slot ||= TimeSlot.first || TimeSlot.create!(start_time: "09:00", end_time: "10:00")
end

#test booking(model)
describe Booking, type: :model do 
    describe '.new_conflict?' do
        before do 
            Booking.destroy_all #clean database
        end

        context 'when no booking' do 
            it 'returns false' do #must no conflict when no other booking
                result = Booking.new_conflict?(test_venue.id, "Venue", Time.now + 1.day, Time.now + 1.day + 3.hours)
                expect(result).to be false
            end
        end

        context 'when there is a approved booking at conflict time slot' do
            before do
                #create approved booking
                test_time_slot = TimeSlot.create!(
                    venue: test_venue,
                    start_time: "09:00", 
                    end_time: "12:00"
                )
                Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "approved"

                )
            end

            it 'return true' do
                result =Booking.new_conflict?(test_venue.id, "Venue", Time.now + 1.day, Time.now+1.day+3.hours)
                expect(result).to be true
            end
        end

        context 'when there is a pending booking in conflict time slot' do
            before do
                #create pending booking
               test_time_slot = TimeSlot.create!(
                    venue: test_venue,
                    start_time: "09:00", 
                    end_time: "12:00"
                )
                Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "pending"

                )
            end
            
            it 'return false' do
                result =Booking.new_conflict?(test_venue.id, "Venue", Time.now+1.day, Time.now+1.day+3.hours)
                expect(result).to be false
            end
        end

        context 'when there is a rejected booking in conflict time slot' do
            before do
                #create rejected booking
                test_time_slot = TimeSlot.create!(
                    venue: test_venue,
                    start_time: "09:00", 
                    end_time: "12:00"
                )
                Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "rejected"

                )
            end
            
            it 'return false' do
                result =Booking.new_conflict?(test_venue.id, "Venue", Time.now+1.day, Time.now+1.day+3.hours)
                expect(result).to be false
            end
        end
    end


    describe '#approved!' do
        before do
            test_time_slot = TimeSlot.create!(
                venue: test_venue,
                start_time: "09:00", 
                end_time: "12:00"
            )
            @booking = Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "pending"

                )
        end

        it 'change status to approved' do
            @booking.approved!
            expect(@booking.status).to eq("approved")
        end
    end

    describe '#rejected!' do
        before do
            test_time_slot = TimeSlot.create!(
                venue: test_venue,
                start_time: "09:00", 
                end_time: "12:00"
            )
            @booking = Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "pending"

                )
        end

        it 'change status to rejected' do
            @booking.rejected!
            expect(@booking.status).to eq ("rejected")
        end
    end
end




    #////////////////

