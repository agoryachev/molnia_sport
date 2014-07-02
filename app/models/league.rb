# encoding: utf-8
# == Schema Information
#
# Table name: leagues # Лиги, чемпионаты
#
#  id                      :integer          not null, primary key
#  category_id             :integer                                   # Внешний ключ для связи с категорией
#  country_id              :integer          default(0)               # Внешний ключ для связи с странами
#  title                   :string(255)      default(""), not null    # Название лиги
#  content                 :text                                      # Описание лиги
#  is_published            :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted              :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled     :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  is_leagues_group_slider :boolean          default(FALSE)           # 1 - показывать в слайдере, 0 - нет
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# Лиги
class League < ActiveRecord::Base
  include SeoMixin
  attr_accessible :category_id,
                  :country_id,
                  :title,
                  :content,
                  :is_published,
                  :is_deleted,
                  :is_comments_enabled,
                  :leagues_group_ids,
                  :is_leagues_group_slider
  # Relations
  # ================================================================
  belongs_to :category
  belongs_to :country
  has_many :years, dependent: :destroy
  has_many :leagues_groups, dependent: :destroy

  # Validations
  # ================================================================
  validates :title, :category_id, :country_id, presence: true

  # Scopes
  # ================================================================
  scope :search_by_year,     ->(params) { joins(:years).where("years.league_year = ?", params[:year]) }
  scope :search_by_category, ->(params) { where(category_id: params[:category_id]) }
  scope :not_deleted,        ->(){ where(is_deleted: false) }
  scope :search,             ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param', param: "%#{params}%") }
  scope :is_published,       ->(){ where(is_published: 1, is_deleted: 0) }
  scope :by_year,            ->(year_id) { joins(:years).where("years.id = ?", year_id) }
  scope :for_slider,         ->(){where(is_leagues_group_slider: true)}

  before_save :is_leagues_group_slider_reset

  # callback-метод, который сбрасывает флажок для отображения результатов лиги
  # в слайдере на главной странице. В каждый момент времени у нас может быть только
  # одна лига, помеченная флажком is_leagues_group_slider
  #
  # @return [Boolean] true
  #
  def is_leagues_group_slider_reset
    if is_leagues_group_slider_changed?
      League.update_all 'is_leagues_group_slider = 0'
    end
    true
  end

  # Возвращает туры для данного обьекта,
  # отсортированный по id
  #
  # @return [Array] массив туров
  #
  def get_leagues_groups
    leagues_groups.includes(:year, matches:[:team_guest, :team_home]).order(:id)
  end

  def by_year(year_id)
    joins(:years).where("years.id = ?", year_id)
  end

  # Возвращает примьер лигу
  #
  # @return [Object] примьер лигу
  #
  def self.primier_league(params = nil)
    if params[:year_id].present?
      is_published.includes(:leagues_groups, :years).where("title LIKE ? AND years.id = ?", "%Премьер-Лига%", params[:year_id]).first
    else
      is_published.includes(:leagues_groups, :years).where("title LIKE ?", "%Премьер-Лига%").first
    end
  end

  # Производит поиск по league_id если присутствует
  # или возвращает примьер лигу
  #
  # @param arg [Hash] params
  # @return [Array] найденное по league_id или примьер лигу
  #
  def self.by_league_id_or_primier_league(params)
    if params[:league_id].present?
      if params[:year_id].present?
        self.includes(:leagues_groups, :years).where("leagues.id = ? and years.id = ?", params[:league_id], params[:year_id]).first
      else
        self.includes(:leagues_groups, :years).find(params[:league_id])
      end
    else
      primier_league(params)
    end
  end

  def self.leagues_groups_for_slider
    league = includes(:leagues_groups).where(is_leagues_group_slider: true).first
    league.leagues_groups.where(round_type: 0) if league
  end

end
