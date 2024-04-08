require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:venue_type) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end

  describe 'associations' do
    it { should have_many(:bookings) }
  end

  describe 'factory' do
    it 'is valid' do
      venue = build(:venue)
      expect(venue).to be_valid
    end
  end

  describe '#as_json' do
    let(:venue) { create(:venue) }
    let(:json_data) { venue.as_json }

    it 'returns a JSON representation of the venue excluding created_at and updated_at' do
      expect(json_data.keys).to contain_exactly('id', 'name', 'venue_type', 'start_time', 'end_time')
      expect(json_data.keys).not_to include('created_at', 'updated_at')
    end

    it 'excludes created_at and updated_at fields' do
      expect(json_data['created_at']).to be_nil
      expect(json_data['updated_at']).to be_nil
    end
  end
end
