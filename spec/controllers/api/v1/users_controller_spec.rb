require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) { create(:user) }
  let(:invalid_attributes) { create(:user, name: '', email: 'invalid', password: '', role: '') }
  let!(:user) { User.create!(valid_attributes[:user]) }

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post :create, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe '#show' do
    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      let(:new_attributes) { { user: { name: 'Updated Name' } } }

      it 'updates the requested user' do
        put :update, params: { id: user.id }.merge(new_attributes)
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it 'renders a JSON response with the user' do
        put :update, params: { id: user.id }.merge(new_attributes)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors' do
        put :update, params: { id: user.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe '#destroy' do
    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it 'returns no content' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
