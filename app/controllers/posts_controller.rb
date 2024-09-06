class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_if_belongs_to_user, except: %i[feed show new create index]

  # create a feed that has only active user, active post, and featured
  # your Post page should only view the Post that the current user create
  # create a method to check if the user can go to show, update, delete of different post which is not his post

  def feed
    @featured_posts = Post.is_featured
    @public_posts = Post.is_active.publish
  end

  # GET /posts or /posts.json
  def index
    @posts = current_user.post.publish.order(created_at: :desc)
    # .order(created_at: :desc) OPTIONAl this make us enable to see the latest added post
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    # turbo edit to retain in the page and the form
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@post, partial: 'posts/form', locals: { post: @post })
      end
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.turbo_stream do
          render turbo_stream: [
            # Turbo create
            turbo_stream.update('new_posts',
                                partial: 'posts/form',
                                locals: { post: Post.new }), # to create the form in our index page id new_posts

            # Turbo read
            turbo_stream.prepend('posts',
                                 partial: 'posts/post',
                                 locals: { post: @post })
          ]
          # to update the tables from the top id posts
          # turbo_stream.append('posts', partial: "posts/form", locals: {  post: @post }) # update from the bottom
        end
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_posts',
                                partial: 'posts/form',
                                locals: { post: @post })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@post, partial: 'posts/post', locals: { post: @post })
        end
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@post, partial: 'posts/form', locals: { post: @post })
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      # Turbo destroy
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }

      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:user_id, :title, :body, :is_active, :is_featured, :publish_date, :image)
  end

  def check_if_belongs_to_user
    return if @post.belong_to_user(current_user.id)

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'You do not have a permission to do this.' }
    end
  end
end
