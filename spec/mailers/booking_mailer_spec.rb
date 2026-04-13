require 'rails_helper'

RSpec.describe BookingMailer, type: :mailer do
  let(:user) do
    instance_double(User, name: 'Mailer User', email: 'mailer.user@example.com')
  end

  let(:venue) do
    instance_double(Venue, name: 'Lecture Theatre 1')
  end

  let(:equipment) do
    instance_double(Equipment, name: 'Projector')
  end

  let(:start_time) { Time.zone.parse('2026-04-20 09:00') }
  let(:end_time) { Time.zone.parse('2026-04-20 11:00') }

  let(:booking) do
    instance_double(
      Booking,
      user: user,
      bookable: venue,
      bookable_type: 'Venue',
      status: 'success',
      start_time: start_time,
      end_time: end_time,
      time_slot: nil
    )
  end

  let(:equipment_booking) do
    instance_double(
      Booking,
      user: user,
      bookable: equipment,
      bookable_type: 'Equipment',
      status: 'success',
      start_time: start_time,
      end_time: end_time,
      time_slot: nil
    )
  end

  describe '#confirmation' do
    context 'for a venue booking' do
      subject(:mail) { described_class.confirmation(booking) }

      it 'builds a booking confirmation email with venue details' do
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq([ApplicationMailer.default[:from]])
        expect(mail.subject).to eq('Booking Confirmation')
        expect(mail.body.encoded).to include('Booking Confirmation')
        expect(mail.body.encoded).to include(user.name)
        expect(mail.body.encoded).to include(venue.name)
        expect(mail.body.encoded).to include('Venue')
        expect(mail.body.encoded).to include('2026-04-20 09:00')
        expect(mail.body.encoded).to include('2026-04-20 11:00')
        expect(mail.body.encoded).to include('success')
      end
    end

    context 'for an equipment booking' do
      subject(:mail) { described_class.confirmation(equipment_booking) }

      it 'builds a booking confirmation email with equipment details' do
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq([ApplicationMailer.default[:from]])
        expect(mail.subject).to eq('Booking Confirmation')
        expect(mail.body.encoded).to include('Booking Confirmation')
        expect(mail.body.encoded).to include(user.name)
        expect(mail.body.encoded).to include(equipment.name)
        expect(mail.body.encoded).to include('Equipment')
        expect(mail.body.encoded).to include('2026-04-20 09:00')
        expect(mail.body.encoded).to include('2026-04-20 11:00')
        expect(mail.body.encoded).to include('success')
      end
    end
  end

  describe '#deletion' do
    context 'for a venue booking' do
      subject(:mail) { described_class.deletion(booking) }

      it 'builds a booking cancellation email with venue details' do
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq([ApplicationMailer.default[:from]])
        expect(mail.subject).to eq('Booking Cancellation')
        expect(mail.body.encoded).to include('Booking Cancellation')
        expect(mail.body.encoded).to include(user.name)
        expect(mail.body.encoded).to include(venue.name)
        expect(mail.body.encoded).to include('Venue')
        expect(mail.body.encoded).to include('2026-04-20 09:00')
        expect(mail.body.encoded).to include('2026-04-20 11:00')
        expect(mail.body.encoded).to include('success')
      end
    end

    context 'for an equipment booking' do
      subject(:mail) { described_class.deletion(equipment_booking) }

      it 'builds a booking cancellation email with equipment details' do
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq([ApplicationMailer.default[:from]])
        expect(mail.subject).to eq('Booking Cancellation')
        expect(mail.body.encoded).to include('Booking Cancellation')
        expect(mail.body.encoded).to include(user.name)
        expect(mail.body.encoded).to include(equipment.name)
        expect(mail.body.encoded).to include('Equipment')
        expect(mail.body.encoded).to include('2026-04-20 09:00')
        expect(mail.body.encoded).to include('2026-04-20 11:00')
        expect(mail.body.encoded).to include('success')
      end
    end
  end
end