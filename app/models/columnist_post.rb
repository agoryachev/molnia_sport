# encoding: utf-8
# == Schema Information
#
# Table name: columnist_posts # Заметки колумнистов
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок заметки
#  subtitle            :string(255)                               # Подзаголовок заметки
#  content             :text             default(""), not null    # Содержимое заметки
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей разделов
#  employee_id         :integer          not null                 # Внешний ключ для связи с таблицей сотрудников
#  columnist_id        :integer          not null                 # Внешний ключ для связи с таблицей колумнистов
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  delta               :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinx)
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Заметки колумнистов
class ColumnistPost < ActiveRecord::Base

  include SeoMixin

  delegate :title, :id, :color, to: :category, prefix: true

  attr_accessible \
    :title,                 # Заголовок заметки
    :subtitle,              # Подзаголовок заметки
    :content,               # Содержимое заметки
    :category_id,           # Внешний ключ для связи с таблицей разделов
    :employee_id,           # Внешний ключ для связи с таблицей сотрудников
    :columnist_id,          # Внешний ключ для связи с таблицей колумнистов
    :is_published,          # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
    :is_deleted,            # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
    :is_comments_enabled,   # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
    :delta,                 # Индекс для полнотекстового поиска (Sphinx)
    :comments_count,        # Количество комментариев к новости
    :published_at           # Дата и время публикации

  # Relations
  # ================================================================
  # has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :category
  belongs_to :employee
  belongs_to :columnist

  # Nested Forms
# ================================================================

  # Validates
# ================================================================
  validates :title, :content, presence: true

  # Callbacks
# ================================================================

  # Scopes
# ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published AND NOT is_deleted AND published_at <= '#{Time.now.utc.to_s(:db)}'") }

  # Methods
# ================================================================

  # Опубликован ли контент?
  #
  # @return [TrueClass|FalseClass]
  #
  def is_published?
    respond_to?(:is_published) && is_published
  end

  # Отложен ли контент?
  #
  # @return [TrueClass|FalseClass] - true, если контент из будущего
  #
  def deferred?
    published_at > Time.now
  end

  # Создает черновик
  #
  # @return [Object] новая заметка колумниста с дефолтними полями
  #
  def self.create_draft(params)
    p = self.new
    p.title        = "Черновик"
    p.published_at = Time.now
    p.employee_id  = params[:employee_id]
    p.columnist    = Columnist.find_by_id(params[:columnist_id])
    p.category     = Category.first
    p.save(validate: false)
    p
  end

end
