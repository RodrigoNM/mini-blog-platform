class Api::V1::PostsController < ApplicationController
  include AuthenticateUser
  include Pundit

  before_action :set_post, only: %i[show update destroy]
  before_action :verify_authorized, only: %i[show create update destroy]

  def index
    if params[:query].present?
      @posts = Post.by_title_or_body(params[:query])
    else
      @posts = Rails.cache.fetch("posts_list", expires_in: 1.hour) do
        Post.includes(:comments).all
      end
    end
    render json: @posts, include: :comments
  end

  def show
    render json: @post, include: :comments
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      expire_posts_cache
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      expire_posts_cache
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    expire_posts_cache
    head :no_content
  end

  private

  def verify_authorized
    authorize Post
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def expire_posts_cache
    Rails.cache.delete("posts_list")
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
