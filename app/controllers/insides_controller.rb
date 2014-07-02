# -*- coding: utf-8 -*-
class InsidesController < ContentController
  before_filter :init_posts, only: :index

  def index
    @insides = Inside.includes(:person, :inside_status).is_published.order("published_at DESC")
    @insides = paginate(@insides)

    # @leagues = League.for_slider.select(:id).includes(:leagues_groups).limit(10)
    # @leagues_groups = @leagues.collect{|league| league.leagues_groups.includes(:matches).last(10) }.flatten

    # @played_matches = @leagues_groups.collect do |group|
    #   group.matches.last_matches.includes(team_home:[:main_image], team_guest: [:main_image]).last(10)
    # end.flatten.uniq

    # @played_matches = @played_matches.last(10)
    @leagues_groups = League.leagues_groups_for_slider
    @league = League.includes(:leagues_groups).where('title = ? AND is_published = ? AND is_deleted = ?', "Чемпионат мира", true, false).first
    leagues_group_ids = @league.leagues_groups.pluck(:id)
    @played_matches = Match.played_matches(leagues_group_ids)

    return render layout: false if request.xhr?
  end

  private

  # Filter: init_posts
  def init_posts
    posts = init_default_posts.order("published_at DESC")
    init_last_posts_last_four_posts(posts)

    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end
