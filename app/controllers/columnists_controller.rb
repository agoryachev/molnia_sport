# -*- coding: utf-8 -*-
class ColumnistsController < ContentController

  # GET /persons/:id
  def show
    @columnist = Columnist.includes(:main_image, :seo).find(params[:id])
    @columnist_posts = ColumnistPost.includes(:seo, category: [:seo])
                                    .is_published
                                    .where(columnist_id: @columnist.id)
    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end