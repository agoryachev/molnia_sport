# -*- coding: utf-8 -*-
class TransfersController < ContentController
  before_filter :init_default_vars, only: [:index, :show]

  # GET transferes
  def index;end

  # GET transferes/:id
  def show
    @team = Team.includes(:main_image, :seo).find(params[:id])
    @transferes_to = Transfer.includes(person: [:main_image, :seo]).is_published.where(team_to_id: @team.id, state: 1)
    @transferes_from = Transfer.includes(person: [:main_image, :seo]).is_published.where(team_from_id: @team.id,state: 1)
    @transferes_interests = Transfer.includes(person: [:main_image, :seo]).is_published.where(team_to_id: @team.id ,state: 0)
    render :show
  end

  # POST transferes/filter_clubs
  def filter_clubs
    category = Category.includes(:teams).find(params[:categoryId]) if params[:categoryId].present?
    country = Country.includes(:teams).find(params[:countryId])    if params[:countryId].present?

    teams = if category.present? && country.present?
      Team.is_published.includes(:seo, :main_image).where(category_id: category.id, country_id: country.id)
    else
      category.teams.is_published.includes(:seo, :main_image) if category.present?
    end

    teams_json = []
    teams_json = teams.map{ |team| make_json_team(team) if team.present? }
    return render json: teams_json
  end

  # Находит все страны переданной категории
  #
  # @param id [Integer] id категории
  # @return [JSON] найденные страны
  #
  def ajax_countries
    render json: Category.find(params[:id]).countries
  end

private
  # инициализирует переменные нужные на страницах
  #
  def init_default_vars
    @category = if params[:category]
      Category.find(params[:category])
    else
      Category.find_by_title('Футбол')
    end
    init_posts
    @transfers = paginate(Transfer.is_published)
    @teams = Team.is_published.includes(:main_image, :seo).where("category_id = (select categories.id from categories where categories.title = ?)", @category.title)
  end

  def init_posts
    @posts = init_default_posts.tagged_with('трансфер')
    @last_post = @posts.pop
    @last_five_posts = last_five_posts(@posts)
    @posts = paginate(@posts)
  end
  # Создает json предствление для модели
  # 
  # @param team [Object] модель
  # @return [Json] json предствление модели
  #
  def make_json_team(team)
    image = team.main_image.present? ? team.main_image.url('_65x65') : '/assets/missing/team/_65x65.jpg'
    {
      id: team.id,
      title: team.title,
    }.merge!({image_url: image})
  end

end