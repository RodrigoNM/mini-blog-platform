require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { { title: 'New Title', body: 'New Body' } }
  let(:invalid_attributes) { { title: '', body: 'Invalid Body' } }

  before do
    sign_in user
  end

  describe '#index' do
    context 'when query parameter is present' do
      it 'returns posts matching the query' do
        create(:post, title: 'Matching Title', body: 'Some content')
        create(:post, title: 'Non-matching Title', body: 'Other content')

        get :index, params: { query: 'Matching' }

        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(1)
      end
    end

    context 'when no query parameter is present' do
      it 'returns all posts' do
        create_list(:post, 3, user: user)

        get :index

        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(3)
      end
    end
  end

  describe '#show' do
    it 'returns the requested post' do
      get :show, params: { id: post.id }

      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(post.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Post' do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Post' do
        expect {
          post :create, params: { post: invalid_attributes }
        }.to change(Post, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'updates the requested post' do
        put :update, params: { id: post.id, post: valid_attributes }
        post.reload

        expect(post.title).to eq('New Title')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the post' do
        put :update, params: { id: post.id, post: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#destroy' do
    it 'destroys the requested post' do
      post_to_destroy = create(:post, user: user)

      expect {
        delete :destroy, params: { id: post_to_destroy.id }
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
