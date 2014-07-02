# -*- coding: utf-8 -*-
class CountriesController < ContentController

  # GET /categories/:category_id/countries/:id
  def show
    @country = Country.includes(categories: [:seo, :leagues]).find(params[:id])
    @category = @country.categories.find(params[:category_id])
    posts = init_default_posts(country_id: @country.id, category_id: @category.id)
    init_last_posts_last_four_posts(posts) unless posts.empty?

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    @teams = Team.includes(:seo, :main_image)
                .is_published
                .by_category(@category.id)
                .by_country(@country.id)
                .order("updated_at DESC")
                .limit(13)
    @leagues = @category.leagues.select(:id).includes(:leagues_groups).limit(10)
    @leagues_groups = @leagues.collect{|league| league.leagues_groups.includes(:matches).last(10) }.flatten
    @matches = @leagues_groups.collect{|group| group.matches.last_matches.includes(team_home:[:main_image], team_guest: [:main_image]).last(10) }.flatten.uniq
    @matches = @matches.last(10)

    # Турнирная таблица для бокового блока
    @tour_table = @leagues_groups.first.leagues_statistics.order("points DESC, goals_diff DESC") if @leagues_groups

    return render 'home/index', layout: false if request.xhr?
  end
end