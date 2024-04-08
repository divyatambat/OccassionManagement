require 'rails_helper'
require 'auth_helper'
require 'faker'

RSpec.describe UsersController, type: :controller do
  let(:role) { create(:role) }
  let!(:user) { FactoryBot.create(:user, role_id: role.id, name: 'abc') }
  let(:token_new) { encode_token(id: user.id) }
  let(:token) { "Bearer #{token_new}" }

  describe 'GET #index' do
    context 'without token' do
      it 'returns unauthorized' do
        get :index, params: { email: Faker::Internet.email }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      let(:invalid_token) { 'Bearer invalid_token' }

      it 'returns unauthorized' do
        request.headers['Authorization'] = invalid_token
        get :index, params: { email: Faker::Internet.email }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 8)} }
    let(:invalid_params) { { name: 'asdfg', email: 'invalid_email', password: 'short' } }

    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(1)
      end

      it 'returns a JSON response with the new user and token' do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['user']['name']).to eq(valid_params[:name])
        expect(json_response['user']['email']).to eq(valid_params[:email])
        expect(json_response['token']).not_to be_empty
      end
    end

    it 'returns a JSON response with error message when user creation fails' do
      post :create, params: { user: invalid_params }
      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('User creation failed')
    end
  end

  describe 'POST #login' do
    it 'log in user' do
      post :login, params: {
        email: 'rohan@gmail.com',
        password: '123'
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns user details' do
      request.headers['Authorization'] = token
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(user.id)
      expect(json_response['name']).to eq(user.name)
      expect(json_response['email']).to eq(user.email)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'returns a JSON response with the updated user' do
        request.headers['Authorization'] = token
        new_name = 'New Name'

        put :update, params: {
          id: user.id,
          user: {
            name: new_name,
          }
        }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
