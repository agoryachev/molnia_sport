# -*- coding: utf-8 -*-
class Backend::ColumnistsController < Backend::ContentController
  before_filter :set_columnist, only: %i(edit update destroy)

  # GET backend/columnists
  def index
    if params[:search].present?
      @columnists = Columnist.search(params[:search])
      return @columnists
    else
      @columnists = Columnist.not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: :name_first)
      @columnists = @columnists.where(is_published: params[:is_published]) if params[:is_published]
    end
  end

  # GET backend/columnists/new
  def new
    @columnist = find_or_model Columnist
    build_media
    build_seo
  end

  # GET backend/columnists/:id/edit
  def edit
    build_media
    build_seo
  end

  # PUT /backend/columnists/:id
  def update
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :columnist).to_json) and return
    end

    if @columnist.update_attributes(params[:columnist])
      clear_session(:columnist)
      update_successful
    else
      build_seo
      update_failed
    end
  end

  # DELETE /backend/columnists/:id
  def destroy
    @columnist.toggle!(:is_deleted)
    @columnist.update_attribute(:is_published, false)
    clear_session_by_id(@columnist)
    destroy_successful
  end

private

  def set_columnist
    @columnist = Columnist.find(params[:id])
  end

  def build_seo
    @seo = @columnist.build_seo unless @columnist.seo.present?
  end

  def build_media
    @columnist.build_main_image if @columnist.main_image.nil?
  end
end
