require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:valid_attributes) { { body: 'This is a comment.' } }
  let(:invalid_attributes) { { body: '' } }

  before do
    sign_in user
  end

  describe '#create' do
    context 'when user is authorized' do
      before do
        allow(user).to receive(:author?).and_return(true)
      end

      context 'with valid parameters' do
        it 'creates a new Comment' do
          expect {
            post :create, params: { post_id: post.id, comment: valid_attributes }
          }.to change(post.comments, :count).by(1)

          expect(response).to have_http_status(:created)
          expect(json_response['body']).to eq('This is a comment.')
        end

        it 'triggers a CommentNotificationJob' do
          expect(CommentNotificationJob).to receive(:perform_later).with(post, instance_of(Comment))

          post :create, params: { post_id: post.id, comment: valid_attributes }
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Comment' do
          expect {
            post :create, params: { post_id: post.id, comment: invalid_attributes }
          }.to change(post.comments, :count).by(0)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is not authorized' do
      before do
        allow(user).to receive(:author?).and_return(false)
      end

      it 'returns unauthorized status' do
        post :create, params: { post_id: post.id, comment: valid_attributes }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq("Only author can add comments on a post")
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
