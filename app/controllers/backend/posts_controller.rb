# encoding: utf-8
class Backend::PostsController < Backend::ContentController
  before_filter :set_categories, only: [:new, :edit, :update]
  before_filter :set_post_statuses, only: [:new, :edit, :update]
  before_filter :set_post, only: [:edit, :update, :destroy]

  # GET /backend/posts(.:format)
  def index
    if params[:search].present? && request.xhr?
      @posts = Post.search(params[:search])
      return @posts
    else
      @posts = Post.includes(:seo, :category)
                      .paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC")
                      .not_deleted
    end
    @posts = @posts.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/posts/new(.:format)
  def new
    @post = find_or_create_obj(:post)
    build_seo
    build_media
  end

  # GET /backend/posts/:id/edit(.:format)
  def edit
    build_seo
    build_media
  end

  # PUT /backend/posts/:id(.:format)
  def update
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :post).to_json) and return
    end
    if @post.update_attributes(params[:post])
      clear_session(:post)
      update_successful
    else
      build_media
      update_failed
    end
  end

  # DELETE /backend/posts/:id(.:format)
  def destroy
    @post.toggle!(:is_deleted)
    @post.update_attribute(:is_published, false)
    clear_session_by_id(@post)
    destroy_successful
  end

  private
  
  def build_media
    @post.build_main_image if @post.main_image.nil?
  end

  def build_seo
    @seo = @post.build_seo unless @post.seo.present?
  end

  def set_categories
    @categories = Category.order(:placement_index)
  end

  def set_post_statuses
    @post_statuses = PostStatus.order(:title)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end