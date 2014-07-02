# -*- coding: utf-8 -*-
class InstagramRecordsController < ContentController
  before_filter :set_last_posts, on: :index

  # GET /instagram_records(.:format)
  def index
    @instagrams = InstagramRecord.not_empty.is_published.order('created_at DESC').map{|instagram| JSON.load instagram.data}
    render "twitter_instagram/index"
  end

  # POST /instagram_records(.:format)
  def create
    instagram = InstagramRecord.new
    id = JSON.parse(Net::HTTP.get(URI("http://api.instagram.com/oembed?url=#{params[:link]}")))['media_id']
    instagram.data = instagram.build_data(InstagramRecord.api_request(:media_item, id))
    instagram.save
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
