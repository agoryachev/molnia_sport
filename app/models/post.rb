# encoding: utf-8
# == Schema Information
#
# Table name: posts # Новости
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null                 # Заголовок новости
#  subtitle              :string(255)                               # Подзаголовок новости
#  content               :text             default(""), not null    # Содержимое новости
#  category_id           :integer          not null                 # Внешний ключ для связи с таблицей разделов
#  employee_id           :integer                                   # Внешний ключ для связи с сотрудниками
#  country_id            :integer                                   # Внешний ключ для связи со странами
#  is_published          :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted            :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled   :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  is_exclusive          :boolean          default(FALSE), not null # Эксклюзивный материал, изображения защищаются водяным знаком
#  post_status_id        :integer                                   # Внешний ключ, для связи с таблицей статусов
#  is_top                :boolean          default(FALSE), not null # 1 - Новость выводится в TOP-новостях, 0 - не выводится
#  is_breaknews          :boolean          default(FALSE)           # Срочная новость
#  delta                 :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinks)
#  comments_count        :integer          default(0), not null     # Количество комментариев к новости
#  published_at          :datetime         not null                 # Дата и время публикации
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

# Новости
class Post < Content

  include SeoMixin

  attr_accessible \
    :subtitle,
    :delta,
    :is_exclusive,
    :post_status_id,
    :is_top,
    :is_breaknews,
    :country_id,
    :person_ids,
    :team_ids

  # Relations
  # ================================================================

  # Заглавное изображение
  has_one :main_image, foreign_key: :media_file_id, class_name: "Post::MainImage", dependent: :destroy
  belongs_to :country

  has_many :publish_persons, as: :publishable, dependent: :destroy
  has_many :persons, through: :publish_persons

  has_many :publish_teams, as: :publishable, dependent: :destroy
  has_many :teams, through: :publish_teams

  # Статусы новостей (инфографика, live из Бразилии, стадионы, судьи)
  has_many :post_statuses

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :search,       ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param OR subtitle LIKE :param', param: "%#{params}%") }
  scope :is_published, ->(){where(is_published: 1, is_deleted: 0)}
  scope :not_in,       ->(array){where("id NOT IN (?)", array || 0)}

  # Nested forms
  # ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }

  before_save do
    if is_exclusive && is_exclusive_changed?
      post_status_id = nil
    end
  end

  # Накладываем или снимаем "водяной знак" на изображение
  # при изменения статуста "Эксклюзивно" или особого статуса новости
  after_save do

    if is_exclusive && is_exclusive_changed?
      add_watermarks
    elsif !is_exclusive && is_exclusive_changed?
      del_watermarks
    end

    if post_status_id.present? && post_status_id_changed?
      post_status = PostStatus.where(id: post_status_id)
      if post_status.size > 0 && post_status[0].image.present?
        add_watermarks("app/assets/images/#{post_status[0].image}")
      end
    elsif post_status_id.nil? && post_status_id_changed?
      del_watermarks
    end

  end

  # Загрузка главного изображения на сервер
  #
  # @param file [Object] объект, представляющий загруженое на сервер изображение
  # @return [Array] параметры уменьшенной копии изображения
  #
  def put_image(file)
    main_image = Post::MainImage.new
    main_image.file = file 
    update_attribute(:main_image, main_image) 
    [main_image.file.url(:_90x90), main_image.id]
  end

  def cut_depricated_tags_from_content()
    content.gsub(/<img\/?[^>]+>/, '')
      .gsub(/<iframe\/?[^>]+>/, '')
      .gsub(/<p>&nbsp\/?[^>]+>/, '')
  end

  private

  # Добавляет водяной знак (эксклюзивно) на главное изображение
  #
  # @param watermark [String] путь к накладываему изображению относительно корня проекта
  # @return [Boolean] true
  #
  def add_watermarks(watermark = 'app/assets/images/exclusive.jpg')
    if main_image.try(:file)
      main_image.file.styles.each do |s|             
        make_watermark(main_image.file, s, watermark)
      end
    end
  end

  # Удаляет водяной знак (эксклюзивно) с главного изображения
  def del_watermarks
    if main_image.try(:file)
      main_image.file.styles.each do |s|
        remove_watermark(main_image.file, s)
      end
    end
  end

  # Собирает 10 последних тегов для из 100 последних опубликованных новостей
  # для опеределенной категории
  #
  # @param category_id [Integer] id категории
  # @return [Array] теги
  #
  def self.get_last_tags(category_id)
    category_id = category_id.to_i
    get_tags(category_id).limit(10)
  end

  # Собирает 10 последних тегов для из 100 последних опубликованных новостей
  # для опеределенной категории
  #
  # @param category_id [Integer] id категории
  # @return [Array] теги
  #
  def self.get_tags(category_id = nil, between = nil)
    category_id = Category.pluck(:id).join(',') unless category_id.present?
    between = if between.present?
      "AND posts.created_at BETWEEN DATE_FORMAT(now(), '%Y-%m-%d 00:00:00') AND DATE_FORMAT(now(), '%Y-%m-%d 23:59:59')"
    else
      ""
    end
    select("tags.name as tag_name, tags.name as tag_name")
    .from("(
      select posts.id 
      from posts
      where posts.category_id IN (#{category_id}) AND posts.is_published = 1 AND posts.is_deleted = 0
      #{between}
      order by posts.id desc 
      limit 500
    ) as posts")
    .joins("join taggings on posts.id = taggings.taggable_id")
    .joins("join tags on tags.id = taggings.tag_id")
    .group("tag_name")
  end

  # Собирает теги для новостей за последние сутки
  #
  # @param category_id [Integer] id категории по которой надо отобрать новотси
  # @return [Array] массив найденных тегов
  #
  def self.get_tags_for_sidebar(category_id = nil)
    get_tags(nil, true)
  end
end
