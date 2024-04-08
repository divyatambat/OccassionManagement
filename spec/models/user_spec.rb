require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:admin_role) { create(:role, name: ROLES[:admin]) }
  let(:customer_role) { create(:role, name: ROLES[:customer]) }

  before do
    create(:user, email: 'cust@josh.com')
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@example.com').for(:email) }
    it { should validate_presence_of(:password_digest).on(:create) }
  end

  describe 'associations' do
    it { should have_many(:bookings) }
  end

  describe '#as_json' do
    it 'returns a JSON representation of the user excluding created_at, updated_at, role_id, and password_digest' do
      json_data = user.as_json

      expect(json_data.keys).to contain_exactly('id', 'name', 'email') # Ensure these keys are present
      expect(json_data.keys).not_to include('created_at', 'updated_at', 'role_id', 'password_digest') # Ensure these keys are excluded
    end
  end

  describe 'callbacks' do
    describe '#set_default_role' do
      it 'sets the default role if not provided' do
        user.save
        expect(user.role.name).to eq(User::DEFAULT_ROLE_NAME)
      end
    end
  end
end
