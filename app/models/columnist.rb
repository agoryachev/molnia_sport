# encoding: utf-8
# == Schema Information
#
# Table name: columnists # Колумнисты
#
#  id           :integer          not null, primary key
#  name_first   :string(255)                            # Имя
#  name_last    :string(255)                            # Фамилия
#  name_v       :string(255)                            # Отчество
#  content      :text                                   # Описание
#  is_published :boolean          default(FALSE)        # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted   :boolean          default(FALSE)        # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Колумнисты
class Columnist < ActiveRecord::Base

  include SeoMixin

  attr_accessible \
    :name_first,   # Имя
    :name_last,    # Фамилия
    :name_v,       # Отчество
    :content,      # Описание
    :is_published, # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
    :is_deleted,   # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
    :main_image_attributes

  # Relations
# ================================================================
  has_one :main_image, foreign_key: :media_file_id, class_name: "Columnist::MainImage", dependent: :destroy

  has_many :columnist_posts, dependent: :destroy

  # Nested Forms
# ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }

  # Validates
# ================================================================
  validates :name_first, :name_last, :content, presence: true
  validates_uniqueness_of :name_first, scope: [:name_last, :content]

  # Callbacks
# ================================================================

  # Scopes
# ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where('is_published = 1 AND is_deleted = 0') }

  # Methods
# ================================================================

  # Загрузка главного изображения на сервер
  #
  # @param file [Object] объект, представляющий загруженое на сервер изображение
  # @return [Array] параметры уменьшенной копии изображения
  #
  def put_image(file)
    main_image = Columnist::MainImage.new
    main_image.file = file
    update_attribute(:main_image, main_image)
    [main_image.file.url(:_90x90), main_image.id]
  end

  # Выводит полное имя колумниста
  #
  # @return [String] полное имя колумниста
  #
  def full_name
    "#{name_first} #{name_last}"
  end


  # Создает черновик для колумниста
  #
  # @return [Object] новый колумнист с дефолтними полями
  #
  def self.create_draft(_)
    p = self.new
    p.name_first = "Имя колумниста"
    p.name_last = "Фамилия колумниста"
    p.name_v = "Отчество колумниста"
    p.content = "Описание колумниста"
    p.save!
    p
  end

end
