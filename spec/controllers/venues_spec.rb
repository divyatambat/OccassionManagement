require 'rails_helper'
require 'auth_helper'
require 'faker'

RSpec.describe VenuesController, type: :controller do
  let(:role) { create(:role) }
  let!(:user) { FactoryBot.create(:user, role_id: role.id, name: "abc") }
  let(:token_new) { encode_token(id: user.id) }
  let(:token) { "Bearer #{token_new}" }
  let!(:venues) { FactoryBot.create_list(:venue, 3) }
  let(:venue) { venues.first }

  describe 'GET #index' do
    context 'with valid authentication' do
      before { request.headers['Authorization'] = token }

      it 'returns venues with venue_type' do
        get :index, params: { venue_type: 'GROUND' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before { request.headers['Authorization'] = token }

      it 'updates the venue' do
        venue = create(:venue)
        put :update, params: { id: venue.id, venue: { name: 'Updated Venue' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'with valid authentication' do
      before { request.headers['Authorization'] = token }

      it 'deletes the venue' do
        venue = create(:venue)
        expect {
          delete :destroy, params: { id: venue.id }
        }.to change(Venue, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
