# encoding: utf-8
class Backend::PagesController < Backend::ContentController
  before_filter :set_page, only: [:edit, :update, :destroy]

  # GET /backend/pages(.:format)
  def index
    if params[:search].present?
      @pages = Page.search(params[:search])
      return @pages
    else
      @pages = Page.not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: 'created_at DESC')
      @pages = @pages.where(is_published: params[:is_published]) if params[:is_published]
    end
  end

  # GET /backend/pages/new(.:format)
  def new
    @page = Page.new
    build_seo
  end

  # POST /backend/pages(.:format)
  def create
    @page = Page.new(params[:page])
    if @page.save
      create_successful
    else
      build_seo
      create_failed
    end
  end

  # GET /backend/pages/:id/edit(.:format)
  def edit
    build_seo
  end

  # PUT /backend/pages/:id(.:format)
  def update
    update_published_column(@page) && return if request.xhr?
    if @page.update_attributes(params[:page])
      update_successful
    else
      build_seo
      update_failed
    end
  end

  # DELETE /backend/pages/:id(.:format)
  def destroy
    @page.toggle!(:is_deleted)
    @page.update_attribute(:is_published, false)
    destroy_successful
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def build_seo
    @seo = @page.build_seo unless @page.seo.present?
  end

end