# -*- coding: utf-8 -*-
class ColumnistPostsController < ContentController

  # GET /columnist_post/:id
  def show
    @columnist_post = ColumnistPost.includes(:seo, columnist: [:main_image], category: [:seo]).is_published.find(params[:id])
    @category = @columnist_post.category
    @last_five_posts = last_five_posts(init_default_posts(category_id: @columnist_post.category.id))

    @galleries = init_sample_galleries
    @videos = init_sample_videos
    return render 'comments/comment', layout: false if request.xhr?
  end

end