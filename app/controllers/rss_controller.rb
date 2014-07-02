# encoding: utf-8
class RssController < ApplicationController

  skip_before_filter :get_main_news

  # GER /rss
  def index
    @posts = Feed.last
    get_contents
    respond_to do |format|
      format.xml { render layout: false }
      format.any { render not_found }
    end
  end

  def yandex_news
    @posts = Feed.last
    get_contents
    respond_to do |format|
      format.xml { render layout: false }
      format.any { render not_found }
    end
  end

private

  # Выдергивает ссылки весь контент из всех постов и помещает в переменные экземпляра @videos и @images
  #
  def get_contents
    get_videos
    get_images
  end

  # Выдергивает ссылки на видео из всех постов и помещает в переменную экземпляра @video
  #
  def get_videos
    @videos = @posts.inject({}) do |result, post|
      result[post.feedable.id] = post.feedable.content.scan(/<video.*?<\/video>/i).inject([]) do |urls, video|
        urls << HTML::Selector.new('video').select(HTML::Document.new(video).root)[0].attributes['src']
      end
      result
    end
  end

  # Выдергивает ссылки на изображения из всех постов и помещает в переменную экземпляра @images
  #
  def get_images
    @images = @posts.inject({}) do |result, post|
      result[post.feedable.id] = post.feedable.content.scan(/<img[^>]+>/i).inject([]) do |urls, image|
        urls << image.scan(/\ssrc=['"]([^"']+)/i)[0][0]
      end
      result
    end
  end

end