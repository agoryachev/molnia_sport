# -*- coding: utf-8 -*-
class CategoriesController < ContentController

  # GET /categories/:id
  def show
    @category = Category.includes(:seo).is_published.find(params[:id])

    posts = @category.posts.is_published.order("published_at DESC")
    init_last_posts_last_four_posts(posts)


    @galleries = init_sample_galleries
    @videos = init_sample_videos

    @galleries = init_sample_galleries
    @videos = init_sample_videos

    @leagues = @category.leagues.for_slider.select(:id).includes(:leagues_groups).limit(10)
    @leagues_groups = @leagues
                        .collect{|league| league.leagues_groups.includes(:matches).last(10) }.flatten

    @matches = @leagues_groups.collect do |group|
      group.matches.last_matches.includes(team_home:[:main_image], team_guest: [:main_image]).last(10)
    end.flatten.uniq

    @matches = @matches.last(10)
    return render 'home/index', layout: false if request.xhr?
  end

  # POST /categories/get_category_colors
  def get_category_colors
    categories = Category.select([:title, :color])
    return render json: categories
  end
end
