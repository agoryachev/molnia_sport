# -*- coding: utf-8 -*-
class PostsController < ContentController

  skip_before_filter :get_main_news, only: :top

  # GET /tag/:tag(.:format)
  def index
    @posts = init_default_posts.tagged_with(params[:tag])
    @posts = paginate(@posts)
    @last_five_posts = last_five_posts(init_default_posts)

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    render 'home/index'
  end

  # GET /posts/:id
  def show
    @post = Post.includes(:seo, :main_image, category:[:seo]).is_published.find(params[:id])
    @common_posts = init_default_posts.tagged_with(@post.tag_list.to_a, any: true).where("posts.id <> ?", @post.id).limit(2)
    @persons = @post.persons.includes(:main_image).limit(2)
    @category = @post.category
    @last_five_posts = last_five_posts(init_default_posts(category_id: @post.category.id))

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    @match = Match.for_sidebar if Setting.show_match_live?
    return render 'comments/comment', layout: false if request.xhr?
  end

  # GET /posts/top/:type
  # Ajax запрос новостей
  def top
    query_hash = request.query_string.split(/&/).inject({}) do |result, param|
      key, val = param.split(/\=/)
      result[key.to_sym] = val
      result
    end
    get_main_news query_hash, params[:type]
    posts = []
    posts = @popular_posts.collect do |post|
      post = post.feedable if post.respond_to?(:feedable)
      {
        title: post.title,
        published_at: post.published_at.strftime('%H:%M'),
        url: polymorphic_url([post.category, post])
      }
    end
    render json: posts
  end

  # GET /get_breaking_news
  # Ajax запрос горячих новостей
  def get_breaking_news
    news_array = []
    breaking_news = init_default_posts.where(is_breaknews: true).limit(3)

    breaking_news.each do |post|
      post.content = post.content.gsub(/<[^>]*>/ui,'')
      news_array << render_to_string(partial: 'posts/post_marquee', layout: false, locals: {post: post})
    end
    render json: {breaking_news: news_array}
  end
end
