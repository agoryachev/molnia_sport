# -*- coding: utf-8 -*-
class Backend::VideosController < Backend::ContentController
  before_filter :set_categories, only: [:new, :edit, :update]
  before_filter :set_video, only: [:edit, :update, :destroy]

  # GET /backend/videos(.:format)
  def index
    if params[:search]
      @videos = Video.search(params[:search])
      return @videos
    else 
      @videos = Video.includes(:main_image, :employee)
      @videos = @videos.where(is_published: params[:is_published]) if params[:is_published]
      @videos = @videos.paginate( page: params[:page],
                                  order: "published_at DESC",
                                  limit: Setting.records_per_page )
    end
    @videos = @videos.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/videos/new
  def new
    @video = find_or_create_obj(:video)
    build_media
    build_seo
  end

  # POST /backend/videos(.:format)  
  def create
    if params[:video].try(:[],:clip_attributes)
      file = params[:video][:clip_attributes][:file]
      params[:video][:duration] = FFMPEG::Movie.new(file.tempfile.to_path.to_s).duration
    end
    @video = Video.new(params[:video])
    if @video.save
      clear_session(:video)
      create_successful
    else
      build_media
      create_failed
    end
  end

  # GET /backend/videos/:id/edit(.:format)  
  def edit
    build_media
    build_seo
  end

  # PUT /backend/videos/:id(.:format)  
  def update
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :video).to_json) and return
    end
    update_published_column(@video) && return if request.xhr?
    if @video.update_attributes(params[:video])
      clear_session(:video)
      update_successful
    else
      build_media
      update_failed
    end
  end

  # DELETE /backend/videos/:id(.:format)  
  def destroy
    if params[:id] == '0'
      redirect_to backend_videos_url
    else
      @video.destroy
      clear_session_by_id(@video)
      destroy_successful
    end
  end

  private

  def build_media
    @video.build_main_image if @video.main_image.nil?
    @video.build_clip if @video.clip.nil?
  end

  def build_seo
    @seo = @video.build_seo unless @video.seo.present?
  end

  def set_categories
    @categories = Category.order(:placement_index)
  end

  # Метод который находит видео по id
  # 
  # @return video [Object] найденное видео
  #
  def set_video
    @video = Video.find(params[:id])
  end

end