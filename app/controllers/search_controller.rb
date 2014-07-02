# -*- coding: utf-8 -*-
class SearchController < ApplicationController
  before_filter :set_last_posts, on: :search

  # GET /search/:query
  # GET XHR /search/:query/more/:page
  def search
    params[:page] ||= 1
    @per_page = Setting.records_per_page || 20
    @publications = ThinkingSphinx.search(CGI::unescape(params[:query]),
                                    { include: [:category, :seo],
                                      classes:  [Post, Video, Gallery],
                                      order: 'published_at DESC',
                                      with: { is_published: 1 }, 
                                      page: params[:page].to_i,
                                      per_page: @per_page
                                    })

    @publications_count = @publications::total_count
    @page = params[:page]
    total = @publications_count / @per_page
    total -= 1 if @publications_count % @per_page == 0
    @is_more = total >= @page.to_i
    return render 'search', layout: false if request.xhr?
  end

private
  # Берет 5 последних новостей для вывода на старнице
  # 
  # @return last_five_posts [Object]
  #
  def set_last_posts
    @last_five_posts = Post.includes(:seo, :main_image, category:[:seo]).not_deleted.is_published.order("created_at DESC").limit(5)
  end

end