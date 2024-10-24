class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(post, comment)
    CommentMailer.new_comment(post, comment).deliver_now
  end
end
