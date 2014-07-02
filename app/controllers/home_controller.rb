# -*- coding: utf-8 -*-
class HomeController < ContentController

  # GET /
  def index
    posts = init_default_posts.order("published_at DESC")
    init_last_posts_last_four_posts(posts)

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    @matches = Match
                .includes(team_home:[:main_image], team_guest: [:main_image])
                .is_published
                .last_matches
                .order("date_at DESC")
                .limit(10)
    @leagues_groups = League.leagues_groups_for_slider
    @league = League.includes(:leagues_groups).where('title = ? AND is_published = ? AND is_deleted = ?', "Чемпионат мира", true, false).first
    leagues_group_ids = @league.leagues_groups.pluck(:id)
    @played_matches = Match.played_matches(leagues_group_ids)

    @match = Match.for_sidebar if Setting.show_match_live?
    return render layout: false if request.xhr?
  end

  # Возвращает темплейты из users по AJAX запросу
  #
  # @param params [Hash] параметры из html
  # @return [Html] найденный partial
  #
  def get_template
    return render partial: "users/#{params[:folder]}/#{params[:template]}"
  end

  # GET /get_stars_in_socials
  def get_stars_in_socials
    tweets = Tweet.not_empty.is_published.order('published_at DESC').limit(4).map{|tweet| JSON.load tweet.data}
    instagrams = InstagramRecord.not_empty.is_published.order('published_at DESC').limit(5).map{|instagram| JSON.load instagram.data}
    render json: {
      stars: render_to_string(partial: 'home/stars_socials', layout: false, locals: {tweets: tweets, instagrams: instagrams})
    }
  end
end