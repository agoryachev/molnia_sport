# -*- coding: utf-8 -*-
class PagesController < ContentController

  # GET /pages/:id
  def show
    @page = Page.find(params[:id])
    @last_five_posts = last_five_posts(init_default_posts)

    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end