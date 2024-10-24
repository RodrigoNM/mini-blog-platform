class Api::V1::CommentsController < ApplicationController
  include AuthenticateUser

  before_action :set_post
  before_action :set_comment, only: %i[update destroy]
  before_action :authorize_user!, only: [ :create ]

  def create
    @post = @post.comments.build(comment_params)
    @comment.user = current_user
    if @post.save
      CommentNotificationJob.perform_later(@post, @comment)
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
    authorize @comment
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user!
    unless current_user.author?
      render json: { error: "Only author can add comments on a post" }, status: :unauthorized
    end
  end
end
