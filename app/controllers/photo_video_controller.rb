# encoding: utf-8
class PhotoVideoController < ContentController

  # GET /photo_video
  def index
    @posts = init_default_posts
    @last_five_posts = last_five_posts(@posts)
    @photos_videos = PhotoVideo.includes(feedable: [:category, :seo, :main_image])
    # отсев с/без учета категорий
    if params['category_id'].present?
      category = params['category_id']
      @category = Category.find(params['category_id'])
      @posts = @posts.where(category_id: params['category_id'])
      @photos_videos = @photos_videos.joins("LEFT JOIN galleries AS g ON g.id = feeds.feedable_id AND feeds.feedable_type = 'Gallery' AND g.category_id = #{category}")
                                     .joins("LEFT JOIN videos AS v ON v.id = feeds.feedable_id AND feeds.feedable_type = 'Video' AND v.category_id = #{category}")
    else
      @photos_videos = @photos_videos.joins("LEFT JOIN galleries AS g ON g.id = feedable_id AND feedable_type = 'Gallery'")
                                     .joins("LEFT JOIN videos AS v ON v.id = feedable_id AND feedable_type = 'Video'")
    end
    # отсев с/без учета типа публикаций
    params[:type] = false unless (!params[:type].nil? and %w(Gallery Video).include? params[:type].classify)
    @photos_videos = if params[:type].present?
                         @photos_videos.where("feeds.feedable_type = ?", params[:type].classify)
                       else
                         @photos_videos.where("feeds.feedable_type IN ('Gallery', 'Video') ")
                       end
    # сортировка по хитам, либо по дате публикации.
    @photos_videos = if params[:filter].present? && params[:filter] == 'popular'
                       # Здесь формируется очень длинный ORDER BY, поэтому ограничиваю его TOP-100 новостями.
                       # Далее сортировка идет по дате публикации.
                       order = Statistics::Top.new.get_top_by_types(['galleries', 'videos'], 100).inject([]) do |result, publication|
                         result << publication.join(':')
                         result
                       end
                       order = "FIELD(CONCAT(feedable_type,':',feedable_id),'#{order.join('\',\'')}')"
                       @photos_videos.order("IF(#{order}, #{order}, 99999), COALESCE(g.published_at, v.published_at) DESC")
                     else
                       @photos_videos.order("COALESCE(g.published_at, v.published_at) DESC")
                     end

    @photos_videos = @photos_videos.where("COALESCE(g.id, v.id) IS NOT NULL AND COALESCE(g.is_deleted, v.is_deleted) = 0 AND COALESCE(g.is_published, v.is_published) = 1")
    @photos_videos_for_slider = @photos_videos.limit(16)
    @photos_videos = paginate(@photos_videos.where("feeds.id not in (?)", @photos_videos_for_slider.pluck(:id)))
    # @photos_videos = @photos_videos.where("g.is_published = ? AND g.is_deleted = ?", 1, 0)
    # @photos_videos = @photos_videos.where("v.is_published = ? AND v.is_deleted = ?", 1, 0)

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    return render layout: false if request.xhr?
  end
end
