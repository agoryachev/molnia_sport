# -*- coding: utf-8 -*-
class VideosController < ContentController

  # GET /categories/:category_id/videos/:id(.:format)
  def show
    @video = Video.includes(:seo, :main_image, :clip, category:[:seo]).find(params[:id])
    @category = @video.category
    @last_five_posts = last_five_posts(init_default_posts(category_id: @video.category.id))

    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end