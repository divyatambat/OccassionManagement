require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:user) { create(:user) }
  let(:venue) { create(:venue) }

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:venue_id) }
    it { should validate_presence_of(:booking_date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:venue) }
  end

  describe 'custom validations' do
    it 'does not allow overlapping bookings' do
      booking = create(:booking, venue: venue, start_time: Time.now, end_time: Time.now + 1.hour)
      overlapping_booking = build(:booking, venue: venue, start_time: Time.now + 30.minutes, end_time: Time.now + 1.hour + 30.minutes)

      expect(overlapping_booking).not_to be_valid
      expect(overlapping_booking.errors[:base]).to include("Booking overlaps with an existing booking")
    end
  end

  describe '#as_json' do
    let(:booking) { create(:booking, user: user, venue: venue) }
    let(:json_data) { booking.as_json }

    it 'returns a JSON representation of the booking excluding created_at and updated_at' do
      expect(json_data.keys).to contain_exactly('id', 'user_id', 'venue_id', 'booking_date', 'start_time', 'end_time', 'status')
      expect(json_data.keys).not_to include('created_at', 'updated_at')
    end
  end

  describe '#no_overlapping_bookings' do
    it 'adds an error if there are overlapping bookings' do
      existing_booking = create(:booking, venue: venue, start_time: Time.now, end_time: Time.now + 1.hour)
      new_booking = build(:booking, venue: venue, start_time: Time.now + 30.minutes, end_time: Time.now + 1.hour + 30.minutes)

      new_booking.valid?
      expect(new_booking.errors[:base]).to include("Booking overlaps with an existing booking")
    end

    it 'does not add an error if there are no overlapping bookings' do
      existing_booking = create(:booking, venue: venue, start_time: Time.now, end_time: Time.now + 1.hour)
      new_booking = build(:booking, venue: venue, start_time: Time.now + 2.hours, end_time: Time.now + 3.hours)

      new_booking.valid?
      expect(new_booking.errors[:base]).to be_empty
    end
  end
end
