# encoding: utf-8
class Backend::ColumnistPostsController < Backend::ContentController
  before_filter :set_categories, only: [:new, :edit, :update]
  before_filter :set_columnist_post, only: [:edit, :update, :destroy]

  # GET /backend/columnists/:columnist_id/columnist_posts(.:format)
  def index
    if params[:search].present? && request.xhr?
      @columnist_posts = ColumnistPost.search(params[:search])
      return @columnist_posts
    else
      @columnist_posts = ColumnistPost.includes(:seo, :category)
                                      .where(columnist_id: params[:columnist_id])
                                      .paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC")
                                      .not_deleted
    end
    @columnist_posts = @columnist_posts.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/columnists/:columnist_id/columnist_posts/new(.:format)
  def new
    @columnist_post = find_or_model(ColumnistPost, {columnist_id: params[:columnist_id], employee_id: current_employee.id})
    build_seo
  end

  # GET /backend/columnists/:columnist_id/columnist_posts/:id/edit(.:format)
  def edit
    build_seo
  end

  # PUT /backend/columnists/:columnist_id/columnist_posts/:id(.:format)
  def update
    if @columnist_post.update_attributes(params[:columnist_post])
      clear_session
      update_successful(@columnist_post.columnist)
    else
      update_failed
    end
  end

  # DELETE /backend/columnists/:columnist_id/columnist_posts/:id(.:format)
  def destroy
    @columnist_post.toggle!(:is_deleted)
    @columnist_post.update_attribute(:is_published, false)
    clear_session
    destroy_successful(@columnist_post.columnist)
  end

private
  
  def build_seo
    @seo = @columnist_post.build_seo unless @columnist_post.seo.present?
  end

  def set_categories
    @categories = Category.order(:placement_index)
  end

  def set_columnist_post
    @columnist_post = ColumnistPost.find(params[:id])
  end

  # Переопределение метода, для очистки сессии при сохранении черновика
  #
  def clear_session
    session_key = "columnistpost_#{params[:columnist_id]}_id"
    session[:new][session_key] = nil if session[:new] && session[:new][session_key].present?
  end

end