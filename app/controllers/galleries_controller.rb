# -*- coding: utf-8 -*-
class GalleriesController < ContentController

  # GET /categories/:category_id/galleries/:id(.:format)
  def show
    @gallery = Gallery.includes(:seo, :main_image, category:[:seo]).find(params[:id])
    @category = @gallery.category
    @last_five_posts = last_five_posts(init_default_posts(category_id: @gallery.category.id))

    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end