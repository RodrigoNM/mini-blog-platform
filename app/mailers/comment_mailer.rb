class CommentMailer < ApplicationMailer
  default from: "notifications@example.com"

  def new_comment(post, comment)
    @post = post
    @comment = comment
    mail(to: @post.user.email, subject: "New Comment on Your Post")
  end
end
