# -*- coding: utf-8 -*-
class TeamsController < ContentController

  # GET /teams/:id
  def show
    @team = Team.includes(:seo, :persons, :main_image, :category, :country).find(params[:id])
    @match = Match.is_published.where('start_at <= utc_timestamp() AND (team_home_id = :team OR team_guest_id = :team)', team: @team.id).order("start_at DESC").limit(1).first
    leagues_group = @match.leagues_group if @match
    @matches = leagues_group.matches if leagues_group

    @posts = @team.posts.order("published_at DESC")
    @last_post = @posts.shift
    @category = @team.category
    @last_five_posts = last_five_posts(init_default_posts(category_id: @category.id))

    @teams = Team.is_published.where("country_id = ? AND id <> ?", @team.country.id, @team.id)
    @transfers = Transfer.is_published.where('team_from_id = :id OR team_to_id = :id', id: @team.id)

    @persons = @team.persons.includes(:seo).persons
    @coach = @team.persons.includes(:seo).coach

    # Турнирная таблица для бокового блока
    @tour_table = leagues_group.leagues_statistics.order("points DESC, goals_diff DESC") if leagues_group
  end

  def get_national_teams
    posts = init_default_posts.order("published_at DESC")
    init_last_posts_last_four_posts(posts)

    @team = Team.includes(:seo, :persons, :main_image, :category, :country).find(params[:id].nil? ? Team.where(title: 'Россия').first.id : params[:id])
    @related_posts = @team.get_related_posts.order("published_at DESC")

    @coach = @team.coach

    @infographics = @related_posts.where(post_status_id: PostStatus.where(title: 'Инфографика')).order("published_at DESC")

    @related_posts_last = @related_posts.shift
    @infographics_last = @infographics.shift

    @related_posts = @related_posts.paginate(page: params[:page], limit: 8)
    @league_group = @team.leagues_statistics.first.leagues_group
    @all_groups = LeaguesGroup.where(league_id: @league_group.league_id, round_type: 0)

    return render layout: false if request.xhr?
  end
end