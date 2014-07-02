# encoding: utf-8
# == Schema Information
#
# Table name: leagues_groups # Группы в рамках лиги, группы
#
#  id         :integer          not null, primary key
#  title      :string(255)      default(""), not null # Название группы
#  date_at    :date                                   # Дата старта игр в рамках группы
#  league_id  :integer          not null              # Внешний ключ для связи с таблицей лиг
#  year_id    :integer                                # Внешний ключ для связи с годами
#  created_at :datetime
#  updated_at :datetime
#

# Групповые этапы в рамках лиги
class LeaguesGroup < ActiveRecord::Base

  ROUND_TYPES_KEYS = {
    'Групповой' => 0, # групповой
    'Плей-офф'  => 1, # плей-офф
  }

  START_STAGE_KEYS = {
    'Финал' => 0,
    'Матч за 3-е место' => 1,
    '1/2'  => 2,
    '1/4'  => 4,
    '1/8'  => 8,
    '1/16'   => 16,
    '1/32'   => 32,
    '1/64'   => 64,
    '1/128'  => 128,
    '1/256'  => 256
  }

  SPEC_STAGE_KEYS = {
    'Финал' => 0,
    'Матч за 3-е место' => 1,
  }

  include SeoMixin
  attr_accessible :title,               # Название группы
                  :date_at,             # Дата старта игр в рамках группы
                  :matches_attributes,
                  :league_id,
                  :year_id,
                  :round_type,
                  :start_stage

  before_save do
    if self.date_at.nil? then self.date_at = Time.now.strftime("%Y-%m-%d") end
  end

  # Relations
  # ================================================================ 
  belongs_to :league
  belongs_to :year
  has_many :matches, dependent: :destroy
  has_many :leagues_statistics, dependent: :destroy

  # Validations
  # ================================================================ 
  validates :title, :league_id, presence: true #:date_at,

  # Nested form
  # ================================================================
  accepts_nested_attributes_for :matches, allow_destroy: true

    # Scopes
  # ================================================================
  scope :by_year, ->(year_id){where(year_id: year_id)}

  # Methods
  # ================================================================

  # Получение всех матчей выбранного тура
  #
  # @return [Array] массив матчей
  #
  def get_matches
    matches.is_published.includes(:team_home, :team_guest)
  end

  def get_json_object
    date = if date_at == nil then Time.now else date_at end

    {
      title: title,
      id: id,
      league_id: league_id,
      year_id: year_id,
      date_at: Russian::strftime(date, "%d.%m.%Y"),
      leagues_groups: true
    }.to_json
  end
end
