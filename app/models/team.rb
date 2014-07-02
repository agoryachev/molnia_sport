# encoding: utf-8
# == Schema Information
#
# Table name: teams # Команды (в рамках групповых видов спорта)
#
#  id                  :integer          not null, primary key
#  title               :string(255)      default(""), not null    # Название команды
#  subtitle            :string(255)                               # Подзаголовок
#  content             :text             default(""), not null    # Описание команды
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  country_id          :integer                                   # Связь со странами
#  category_id         :integer          not null                 # Внешний ключ для связи с категорией
#  created_at          :datetime
#  updated_at          :datetime
#

# Команды (в рамках групповых видов спорта)
class Team < ActiveRecord::Base
  include SeoMixin
  attr_accessible :person_ids,
                  :category_id,
                  :country_id,
                  :main_image_attributes,
                  :title,
                  :subtitle,
                  :content,
                  :is_published,
                  :is_deleted,
                  :is_comments_enabled,
                  :year_of_foundation,
                  :coach_id

  # Relations
  # ================================================================
  belongs_to :category
  belongs_to :country

  has_one  :main_image, foreign_key: :media_file_id, class_name: "Team::MainImage", dependent: :destroy
  has_many :teams_persons, dependent: :destroy
  has_many :persons, through: :teams_persons
  has_many :leagues_statistics, dependent: :destroy

  has_many :publish_teams, dependent: :destroy
  has_many :posts, through: :publish_teams, source: :publishable, source_type: 'Post'
  has_many :galleries, through: :publish_teams, source: :publishable, source_type: 'Gallery'
  has_many :videos, through: :publish_teams, source: :publishable, source_type: 'Video'

  has_many :events
  has_many :team_formations

  # Validates
  # ================================================================
  validates :title, :country_id, presence: true
  validates_uniqueness_of :title, message: ' с таким именем уже существует'


  # Nested forms
  # ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }

  # Scopes
  # ================================================================
  default_scope { where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published = 1 AND is_deleted = 0") }
  scope :search,       ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param OR subtitle LIKE :param', param: "%#{params}%") }
  scope :by_category,  ->(category_id){ where("category_id = ?", category_id) }
  scope :by_country,   ->(country_id){ where("country_id = ?", country_id) }

  def coach
    Person.where(id: coach_id).first
  end

  def get_related_posts
    Post.joins("JOIN publish_teams ON publish_teams.publishable_type = 'Post' AND publish_teams.publishable_id = posts.id JOIN (SELECT * FROM teams WHERE id = #{id}) AS teams ON publish_teams.team_id = teams.id").group('publish_teams.publishable_id')
  end

  def self.by_team_or_guest_id(last_leagues_group_id)
    where("
      teams.id in
          (select matches.team_home_id from matches where leagues_group_id = :last_leagues_group_id)
        or
      teams.id in
          (select matches.team_guest_id from matches where leagues_group_id = :last_leagues_group_id)
    ", {last_leagues_group_id: last_leagues_group_id})
  end

  # Загрузка главного изображения на сервер
  def put_image(file)
    main_image = Team::MainImage.new
    main_image.file = file
    update_attribute(:main_image, main_image)
    [main_image.file.url(:_90x90), main_image.id]
  end

  def to_hash(target = nil)
    case target
    when :event    then { id: id, title: title }
    else {}
    end
  end
end
