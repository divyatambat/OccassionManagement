require 'rails_helper'
require 'auth_helper'

RSpec.describe BookingsController, type: :controller do
  let(:role) { create(:role) }
  let!(:user) { FactoryBot.create(:user, role_id: role.id, name: "abc") }
  let(:token_new) { encode_token(id: user.id) }
  let(:token) { "Bearer #{token_new}" }
  let!(:venues) { FactoryBot.create_list(:venue, 3) }
  let(:venue) { venues.first }
  let!(:booking) { FactoryBot.create(:booking, user: user, venue: venue) }
  let(:valid_params) {
    {
      user_id: user.id,
      venue_id: venue.id,
      booking_date: Faker::Date.forward(days: 30),
      start_time: Faker::Time.between_dates(from: Date.today, to: Date.today + 30.days, period: :day),
      end_time: Faker::Time.between_dates(from: Date.today, to: Date.today + 30.days, period: :day),
      status: STATUSES.sample
    }
  }

  describe 'GET #index' do
    context 'booking of a particular user' do
      it 'renders JSON with email' do
        request.headers["Authorization"] = token
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'booking for a particular venue' do
      it 'renders JSON with email' do
        request.headers["Authorization"] = token
        get :index, params: { venue_id: venue.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'booking between particular times' do
      it 'renders JSON with start time and end time' do
        request.headers["Authorization"] = token
        get :index, params: { start_time: Time.now, end_time: Time.now + 5.hours }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'bookings of particular date' do
      it 'renders JSON with date' do
        request.headers["Authorization"] = token
        get :index, params: { booking_date: Faker::Date.forward(days: 30)}
        expect(response).to have_http_status(:ok)
      end
    end

    context 'booking as per status' do
      it 'renders JSON with status' do
        request.headers["Authorization"] = token
        get :index, params: { status: STATUSES.sample}
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      let(:invalid_token) { "Bearer invalid_token" }

      it 'returns unauthorized' do
        request.headers["Authorization"] = invalid_token
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    it 'returns JSON representation of the booking' do
      request.headers["Authorization"] = "Bearer #{encode_token(id: user.id)}"
      get :show, params: { id: booking.id }
      expect(response).to have_http_status(:ok)
      expected_json = booking.as_json
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the booking' do
        request.headers["Authorization"] = "Bearer #{token}"
        put :update, params: { id: booking.id, booking: { status: 'updated_status' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('updated_status')
      end
    end
  end

  describe 'DELETE #destroy' do
    it "delete booking" do
      request.headers["Authorization"] = "Bearer #{token}"
      delete :destroy, params: {
        id: booking.id,
      }
      expect(response).to have_http_status(:ok)
    end
  end
end
