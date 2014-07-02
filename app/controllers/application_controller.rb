# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_filter {@categories = Category.includes(:seo, :children, :leagues).group("leagues.title").where(is_published: true).roots}
  before_filter :set_categories, :get_last_columnists_posts
  before_filter {@pages = Page.includes(:seo).is_published}
  # before_filter { |controller| get_main_news unless params[:controller].in?(['calendars', 'sessions', 'registrations']) }
  before_filter :get_main_news

private
  # Главные новости для вывода в сайдбар
  #
  # @param [Hash] controller_info - параметры с которыми был сделан AJAX-запрос
  # @param [String] sort_type     - last/popular/discussed
  # @return popular_posts [Array] массив новостей
  #
  def get_main_news(controller_info = nil, sort_type = 'last')
    controller_info ||= params
    model_name = controller_info[:controller].classify

    #model_name = 'Feed' if %w(home search).include? controller_info[:controller]
    begin
      model = Object.const_get model_name
    rescue Exception => e
      model = Object.const_get 'Feed'
    end
    
    category_id = set_category_id(controller_info)
    method_name = "#{sort_type}_5_for_main_news".to_sym
    @popular_posts = populate_posts(model, method_name, category_id)
    @popular_posts
  end

  # Загружает последние 5 публикаций колумнистов для вывода в сайдбар
  #
  # @return NilClass
  #
  def get_last_columnists_posts
    @columnists_posts = ColumnistPost.includes(:category, columnist: [:main_image])
                                     .is_published
                                     .order('published_at DESC')
                                     .limit(5)
  end

  # Ищет id категории
  # 
  # @param controller_info [Hash] хеш с параметрами пришедшими с сайта
  # @return id [Integer] возвращает id категории
  #
  def set_category_id(controller_info)
    controller_info[:controller] == 'categories' ? controller_info[:id] : controller_info[:category_id]
  end

  # Выбирает массив последних новостей для заданной модели
  # 
  # @param model [Object] сущность для которой нужны новости
  # @param method_name [String] метод которым берем новости
  # @param category_id [Integer] поиск новостей по категории если она есть
  # @return [Array] найденные новости
  #
  def populate_posts(model, method_name, category_id)
    model = (model.respond_to? method_name) ? model : Post
    model = set_right_includes(model)
    model.send(method_name, category_id)
  end

  # Делает правильные includes в зависимости от сущности
  # 
  # @param model [Object] модель
  # @return [Object] подготовленная модель с зависимостями
  #
  def set_right_includes(model)
    if ['Feed', 'PhotoVideo'].include?(model.name)
      model.includes(feedable: [:seo, :category]) 
    else
      model.includes(:seo, :category)
    end
  end

  # def set_last_five_posts
  #   @last_five_posts = Post.includes(:seo, :main_image).where(category_id: params[:id]).order("created_at DESC").limit(5)
  # end

  # Инициализация массива категорий для главной навигации
  #
  # @return categories [Array] массив категорий
  #
  def set_categories
    @categories = Category
                    .includes(:seo, :countries)
                    .is_published
                    .order(:placement_index)
  end

  # Вызов ошибки 404
  #
  # @private
  #
  # @raise [ActionController::RoutingError] вызывает ошибку Not Found
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
