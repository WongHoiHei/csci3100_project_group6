require 'rails_helper'

def test_user
    @test_user ||= User.first || User.create!(
        email: "test@gmail.com", name: "test user", role:"student", password: "123456", password_confirmation: "123456"
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

    describe '#pending!' do
        before do
            @booking = Booking.create!(
                    user: test_user, bookable: test_venue, time_slot: test_time_slot, start_time: Time.now + 1.day,
                    end_time: Time.now + 1.day + 3.hours, status: "approved"

                )
        end

        it 'change status to pending' do
            @booking.pending!
            expect(@booking.status).to eq("pending")
        end
    end

    describe '#revise_conflict?' do
        before do
            Booking.destroy_all
            @start_time = Time.zone.parse('2026-04-21 09:00')
            @end_time = Time.zone.parse('2026-04-21 11:00')
        end

        it 'returns true when another approved booking overlaps' do
            Booking.create!(
                user: test_user,
                bookable: test_venue,
                time_slot: test_time_slot,
                start_time: @start_time,
                end_time: @end_time,
                status: 'approved'
            )

            booking = Booking.create!(
                user: test_user,
                bookable: test_venue,
                time_slot: test_time_slot,
                start_time: @start_time + 30.minutes,
                end_time: @end_time + 30.minutes,
                status: 'pending'
            )

            expect(booking.revise_conflict?).to be true
        end

        it 'returns false when the overlapping booking is itself' do
            booking = Booking.create!(
                user: test_user,
                bookable: test_venue,
                time_slot: test_time_slot,
                start_time: @start_time,
                end_time: @end_time,
                status: 'approved'
            )

            expect(booking.revise_conflict?).to be false
        end

        it 'returns false when overlaps are not approved' do
            Booking.create!(
                user: test_user,
                bookable: test_venue,
                time_slot: test_time_slot,
                start_time: @start_time,
                end_time: @end_time,
                status: 'pending'
            )

            booking = Booking.create!(
                user: test_user,
                bookable: test_venue,
                time_slot: test_time_slot,
                start_time: @start_time + 15.minutes,
                end_time: @end_time + 15.minutes,
                status: 'pending'
            )

            expect(booking.revise_conflict?).to be false
        end
    end

    describe 'status predicates' do
        it 'reports approved? correctly' do
            booking = Booking.new(status: 'approved')
            expect(booking.approved?).to be true
            expect(booking.pending?).to be false
            expect(booking.rejected?).to be false
        end

        it 'reports pending? correctly' do
            booking = Booking.new(status: 'pending')
            expect(booking.approved?).to be false
            expect(booking.pending?).to be true
            expect(booking.rejected?).to be false
        end

        it 'reports rejected? correctly' do
            booking = Booking.new(status: 'rejected')
            expect(booking.approved?).to be false
            expect(booking.pending?).to be false
            expect(booking.rejected?).to be true
        end
    end
end




    #////////////////

