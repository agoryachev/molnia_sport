# -*- coding: utf-8 -*-
class Backend::GalleriesController < Backend::ContentController
  before_filter :set_gallery, only: [:edit, :update, :destroy]
  before_filter :set_categories, only: [:new, :edit, :update]

  # GET /backend/galleries
  def index
    if params[:search].present?
      @galleries = Gallery.search(params[:search])
      return @galleries
    else
      @galleries = Gallery.includes(:gallery_files, :category).not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC")
      @galleries = @galleries.where(is_published: params[:is_published]) if params[:is_published]
    end
  end

  def new
    @gallery = find_or_create_obj(:gallery)
    build_seo
    build_media
  end

  # POST /backend/galleries(.:format)
  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      clear_session(:gallery)
      create_successful
    else
      build_media
      build_seo
      create_failed
    end
  end

  # GET /backend/galleries/:id/edit(.:format)
  def edit
    build_seo
    build_media
  end

  # PUT /backend/galleries/:id(.:format)
  def update
    if params['_plupload_upload']
      pars = asynch_upload(params, :gallery)
      unless pars.class.name == 'TrueClass'
        gallery_files_id = MediaFile.find(pars[:id]).media_file_id
        pars.merge!({gallery_files_id: gallery_files_id})
      end
      return render(json: pars.to_json)
    end

    if @gallery.update_attributes(params[:gallery])
      clear_session(:gallery)
      update_successful
    else
      build_media
      update_failed
    end

  end

  # DELETE /backend/galleries/:id(.:format)
  def destroy
    @gallery.toggle!(:is_deleted)
    @gallery.update_attribute(:is_published, false)
    clear_session_by_id(@gallery)
    destroy_successful
  end

  private
    def build_media
      @gallery.build_main_image if @gallery.main_image.nil?
    end

    def build_seo
      @seo = @gallery.build_seo unless @gallery.seo.present?
    end

    def set_categories
      @categories = Category.order(:placement_index)
    end

    def set_gallery
      @gallery = Gallery.find(params[:id])
    end


end
