# encoding: utf-8
# == Schema Information
#
# Table name: persons # Персоналии (игрок, тренер, владелец клуба и т.п.)
#
#  id                  :integer          not null, primary key
#  name_first          :string(255)      default(""), not null    # Имя
#  name_last           :string(255)      default(""), not null    # Фамилия
#  name_v              :string(255)                               # Отчество
#  content             :text             default(""), not null    # Описание
#  instagram           :string(255)                               # Ссылка на instagram
#  twitter             :string(255)                               # Ссылка на twitter
#  character_id        :integer                                   # Связь с таблицей character
#  number              :integer                                   # Номер игрока
#  height              :integer                                   # Рост
#  weight              :integer                                   # Вес
#  birthday            :date                                      # Дата рождения
#  citizenship         :string(255)                               # Гражданство
#  cost                :string(255)                               # Трансферная стоимость
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Персоналии (игрок, тренер, владелец клуба и т.п.)
class Person < ActiveRecord::Base
  attr_accessible \
    :name_first,          # Имя
    :name_last,           # Фамилия
    :name_v,              # Отчество
    :content,             # Описание
    :is_published,        # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
    :is_deleted,          # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
    :is_comments_enabled, # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
    :main_image_attributes,
    :twitter,             # Ссылка на twitter
    :instagram,           # Ссылка на instagram
    :character_id,        # Связь с таблицей character
    :number,              # Номер игрока
    :height,              # Рост
    :weight,              # Вес
    :birthday,            # Дата рождения
    :citizenship,         # Гражданство
    :cost,                # Трансферная стоимость
    :seo_attributes


  # Relations
  # ================================================================
  has_many :teams_persons, dependent: :destroy
  has_many :teams, through: :teams_persons
  has_one :main_image, foreign_key: :media_file_id, class_name: "Person::MainImage", dependent: :destroy
  has_one :seo, as: :seoable, dependent: :destroy
  has_many :transfers, dependent: :destroy
  belongs_to :character

  has_many :publish_persons, dependent: :destroy
  has_many :posts, through: :publish_persons, source: :publishable, source_type: 'Post'
  has_many :galleries, through: :publish_persons, source: :publishable, source_type: 'Gallery'
  has_many :videos, through: :publish_persons, source: :publishable, source_type: 'Video'

  # Validations
  # ================================================================
  validates_uniqueness_of :name_first, scope: [:name_last, :content]
  validates :name_first, :name_last, presence: true

  # Scopes
  # ================================================================
  default_scope { where('is_deleted = 0') }
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where('is_published = 1 AND is_deleted = 0') }
  scope :search, ->(params){ not_deleted.where('name_first LIKE :param OR name_last LIKE :param OR name_v LIKE :param', param: "%#{params}%") }
  # Nested forms
  # ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }
  accepts_nested_attributes_for :seo, allow_destroy: true

  before_save ->(){ self.seo.slug = make_title if self.seo.present? }

  # Methods
  # ================================================================
  # Ищет персону у которого амплуа Гл. тренер
  #
  # @return [Object] найденный тренер
  #
  def self.coach
    includes(:character, :main_image).where("characters.title = 'Гл. тренер'").first
  end

  # Ищет персону у которого амплуа Судья
  #
  # @return [Object] найденный судья
  #
  def self.referee
    includes(:character, :main_image).where("characters.title = 'Судья'").first
  end

  # Ищет Судей
  #
  # @return [Object] найденный судья
  #
  def self.referees
    includes(:character, :main_image).where("characters.title = 'Судья'")
  end

  # Ищет игроков у которорых амплуа не Гл. тренер
  #
  # @return [Object] найденные игроки
  #
  def self.persons
    includes(:character, :main_image).where("characters.title NOT IN ('Гл. тренер', 'Судья')")
  end
  # Поис по имени и фамилии гостя
  #
  # @param query [String] имя или фамилия
  # @return [Array] массив найденных гостей
  #
  def self.search_by_name_or_last_name(query)
    where(arel_table[:name_first].matches("%#{query}%").or(arel_table[:name_last].matches("%#{query}%")))
  end

  # Загрузка главного изображения на сервер
  def put_image(file)
    main_image = Person::MainImage.new
    main_image.file = file
    update_attribute(:main_image, main_image)
    [main_image.file.url(:_90x90), main_image.id]
  end

  # Выводит полное имя игрока
  #
  # @return [String] полное имя игрока
  #
  def full_name
    "#{name_first} #{name_last}"
  end

  # Создает черновик для игрока
  #
  # @return [Object] новый игрок с дефолтними полями и не опубликованный
  #
  def self.create_draft(_)
    p = self.new
    p.name_first = "Имя игрока"
    p.name_last = "Фамилия игрока"
    p.name_v = "Отчество игрока"
    p.save(validate: false)
    p
  end

  def self.age(person_id)
    select("FLOOR(DATEDIFF( CURRENT_DATE(), birthday) / 365.25) as current_age").find(person_id).current_age
  end

  def to_hash(target = nil, custom = {})
    case target
    when :event then { id: id, name: full_name, number: number, last_name: name_last }
    else attributes
    end.merge(custom)
  end

  def make_title
    if self.respond_to?(:title)
      title.downcase.strip.to_ascii.gsub(' ', '_').gsub(/[^\w-]/, '')
    elsif self.respond_to?(:full_name)
      full_name.downcase.strip.to_ascii.gsub(' ', '_').gsub(/[^\w-]/, '')
    end
  end

  def to_param
    "#{id}-#{[name_first, name_last].join('_')}"
  end
end
