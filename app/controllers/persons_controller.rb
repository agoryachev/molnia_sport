# -*- coding: utf-8 -*-
class PersonsController < ContentController

  # GET /persons/:id
  def show
    @person = Person.includes(:teams).find(params[:id])
    @team = @person.teams.first
    @match = Match
              .is_published
              .where('start_at <= utc_timestamp() AND (team_home_id = :team OR team_guest_id = :team)', team: @team.id)
              .order("start_at DESC")
              .limit(1)
              .first if @team
    @leagues_group = @match.leagues_group if @match
    @matches = @leagues_group.matches if @leagues_group

    @posts = @person.posts.order("published_at DESC")
    @last_post = @posts.shift
    @category = @team.category if @team.present?
    @last_five_posts = last_five_posts(init_default_posts(category_id: @category.id)) if @category
    @teams = Team
              .is_published
              .includes(:seo, :main_image)
              .where("country_id = ?", @team.country.id) if @team.present?

    # Турнирная таблица для бокового блока
    @tour_table = @leagues_group.leagues_statistics.order("points DESC, goals_diff DESC") if @leagues_group

    @last_five_posts = last_five_posts(init_default_posts)
    @galleries = init_sample_galleries
    @videos = init_sample_videos
  end
end