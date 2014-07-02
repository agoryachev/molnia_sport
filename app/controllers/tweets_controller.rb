# -*- coding: utf-8 -*-
class TweetsController < ContentController
  before_filter :set_last_posts, on: :index

  # GET /twitter_records(.:format)
  def index
    @tweets = Tweet.not_empty.is_published.order('created_at DESC').map{|tweet| JSON.load tweet.data}
    render "twitter_instagram/index"
  end
  # POST /tweets(.:format)
  def create
    tweet = Tweet.new
    tweet.data = tweet.build_data(Tweet.api_request 'status', params[:link].split('/').last)
    tweet.save
    redirect_to root_path
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
