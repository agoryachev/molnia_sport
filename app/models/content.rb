# encoding: utf-8
require 'paperclip_processors/watermark'

class Content < ActiveRecord::Base
  include SeoMixin
  include Paperclip
  self.abstract_class = true

  # Тэги
  acts_as_taggable

  delegate :title, :id, :color, to: :category, prefix: true

  attr_accessible :title,
                  :content,
                  :is_published,
                  :is_deleted,
                  :is_comments_enabled,
                  :category_id,           # Внешний ключ для связи с таблицей категории
                  :comments_count,        # Количество комментариев к новости
                  :main_image_attributes, # nested аттрибут для главного изображения
                  :tag_list,              # Теги
                  :employee_id,           # Внешний ключ для связи с таблицей сотрудников
                  :published_at,          # Дата и время публикации
                  :authors_attributes,    # Атрибуты вложенной формы Автора
                  :author_ids             # Идентификаторы связанных авторов

  # Relations
  # ================================================================
  # has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :category
  belongs_to :employee

  # Несколько авторов
  has_many :authors_publications, as: :authorable, dependent: :destroy
  has_many :authors, dependent: :destroy, through: :authors_publications

  has_one :feed, as: :feedable, dependent: :destroy

  # Nested Forms
  # ================================================================
  accepts_nested_attributes_for :authors, allow_destroy: true

  # Validates
  # ================================================================
  validates :title, :content, presence: true

  # Callbacks
  # ================================================================
  after_create {self.create_feed}

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published = 1 AND is_deleted = 0 AND published_at <= '#{Time.now.utc.to_s(:db)}'") }
  scope :category_id,  ->(category_id) { where("category_id = ?", category_id) }

  # Methods
  # ================================================================

  class << self
    def get_model
      if %w(Post Gallery Video).include? self.name then self else Post end
    end

    def get_publications(model)
      model.select([:id, :title, :published_at, :category_id]).is_published
    end

    # Загружает 5 последних публикаций
    #
    # @param [Fixnum] category_id - ID категории (вида спорта)
    # @return [Array] - массив публикаций
    #
    def last_5_for_main_news category_id=nil
      model = get_model
      publications = get_publications(model).order("published_at DESC").limit(5)
      publications = publications.category_id(category_id) if category_id
      publications
    end

    # Загружает 5 самых посещаемых публикаций
    #
    # @param [Fixnum] category_id - ID категории (вида спорта)
    # @return [Array] - массив публикаций
    #
    def popular_5_for_main_news category_id=nil
      model = get_model
      top_publications = Statistics::Top.new.get_top_by_type(model.name.downcase.pluralize).join(',')
      publications = get_publications(model)
                          .where("`id` IN (#{top_publications})")
                          .order("FIELD(`id`,#{top_publications})")
                          .limit(5)
      publications = publications.category_id(category_id) if category_id
      publications
    end

    # Загружает 5 самых обсуждаемых публикаций
    #
    # @param [Fixnum] category_id - ID категории (вида спорта)
    # @return [Array] - массив публикаций
    #
    def discussed_5_for_main_news category_id=nil
      model = get_model
      publications = get_publications(model).order("comments_count DESC").limit(5)
      publications = publications.category_id(category_id) if category_id
      publications
    end

  end

  # Опубликован ли контент?
  # 
  # * *Returns* :
  #   - Boolean
  #
  def is_published?
    respond_to?(:is_published) && is_published
  end

  # Отложен ли контент? Возвращает true, если контент из будущего
  # 
  # * *Returns* :
  #   - Boolean
  #
  def deferred?
    published_at > Time.now
  end

  # Возвращает количество хитов (просмотров)
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [Integer]
  #
  def hits date=nil
    Statistics::Visits::hits(self.id, self.class.name, date)
  end

  # Возвращает количество хитов (просмотров)
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [Integer]
  #
  def hosts date=nil
    Statistics::Visits::hosts(self.id, self.class.name, date)
  end

end