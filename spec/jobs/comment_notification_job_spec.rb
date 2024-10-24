require 'rails_helper'

RSpec.describe CommentNotificationJob, type: :job do
  let(:post) { create(:post) }
  let(:comment) { create(:comment, post: post) }

  context 'when creating a new comment' do
    it 'sends an email' do
      expect {
        CommentNotificationJob.perform_later(post, comment)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
