# -*- coding: utf-8 -*-
class ContentController < ApplicationController

  # Кириллические статусы потсов для поиска и тайтлов страниц
  #
  CYRILLIC_POST_STATUSES = {
    judges:       'Судьи',
    stadiums:     'Стадионы',
    infographics: 'Инфографика',
    live:         'Live из Бразилии'
  }.freeze

  # Инициализирует новости
  # 
  # @param kwargs [Hash] аргументы для фильтрации
  # @return [Array] массив новостей
  #
  def init_default_posts(**kwargs)
    posts = Post.includes(:seo, :main_image, category:[:seo])
                .is_published
                .order("published_at DESC")
    if kwargs.present?
      posts = posts.where(kwargs)
    end
    posts
  end

  # Инициализирует фото для виджета фото/видео
  # 
  # @param kwargs [Hash] аргументы для фильтрации
  # @return [Array] массив новостей
  #

  def init_sample_galleries(**kwargs)
    galleries = Gallery.includes(:seo, :main_image, category:[:seo]).is_published.sample(4)
    if kwargs.present?
      galleries = galleries.where(kwargs)
    end
    galleries
  end

  # Инициализирует видео для виджета фото/видео
  # 
  # @param kwargs [Hash] аргументы для фильтрации
  # @return [Array] массив новостей
  #

  def init_sample_videos(**kwargs)
    videos = Video.includes(:seo, :main_image, :clip, category:[:seo]).is_published.sample(4)
    if kwargs.present?
      videos = galleries.where(kwargs)
    end
    videos
  end

  # Последние 5 новостей
  # 
  # @param posts [Array] массив новостей
  # @return [Array] массив с 5 новостями посденими
  #
  def last_five_posts(posts)
    posts.limit(5)
  end

  def init_last_posts_last_four_posts(posts)
    # Главная новость
    @last_post = posts.first
    # Top4 новостей
    @last_four_posts = posts.not_in(@last_post.id).limit(3)
    # Top5-новостей
    exclude = @last_four_posts.pluck(:id)
    exclude << @last_post.id

    @last_five_posts = posts.not_in(exclude).limit(5)
    exclude << @last_five_posts.pluck(:id)

    @posts = posts.not_in(exclude.flatten)
    @posts = paginate(@posts)
  end

  def get_posts_for_top_bottom_boxes(posts)
    top_box = []
    bottom_box = []
    exclude = []
    posts.limit(params[:count].to_i).each do |post|
      exclude << post.id
      top_box << render_to_string(partial: 'posts/post', layout: false, locals: {post: post})
    end
    exclude = exclude.empty? ? 0 : exclude
    posts.not_in(exclude.flatten)
          .limit(Setting.records_per_page - params[:count].to_i)
          .each do |post|
            bottom_box << render_to_string(partial: 'posts/post', layout: false, locals: {post: post})
          end
    [top_box, bottom_box]
  end

  # Метод обертка над методом вызова пагинации
  # 
  # @param arg [Array] массив для которого надо вызвать пагинацию
  # @return [Array] массив
  #
  def paginate(model)
    model.paginate(page: params[:page], limit: Setting.records_per_page)
  end

  # Метод для перевода латинского статуса поста в его кириллическое обозначение
  def get_cyrillic_post_status(status)
    CYRILLIC_POST_STATUSES[status.downcase.to_sym]
  end
end