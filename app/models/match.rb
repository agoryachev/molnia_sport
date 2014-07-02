# encoding: utf-8
# == Schema Information
#
# Table name: matches # Матчи
#
#  id                  :integer          not null, primary key
#  team_home_id        :integer                                   # Внешний ключ для связи с принимающей командой
#  team_guest_id       :integer                                   # Внешний ключ для связи с гостевой командой
#  leagues_group_id    :integer                                   # Связь с таблицей группы
#  referee_id          :integer                                   # Внешний ключ для судьи матча
#  title               :string(255)                               # Название матча
#  content             :text                                      # Описание матча
#  is_published        :boolean          default(TRUE)            # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  count_home          :integer                                   # Очки принимащей команды (сколько забили голов/шайб гостевой команде)
#  count_guest         :integer                                   # Очки гостевой команды (сколько забили голов/шайб принимающей команде)
#  date_at             :date             not null                 # Дата проведения матча
#  start_at            :time                                      # Время начала матча
#  finish_at           :time                                      # Время окончания матча
#  team_home_scheme_id  :integer                                  # Предматчевая расстановка хозяев (id tactical_scheme)
#  team_guest_scheme_id :integer                                  # Предматчевая расстановка гостей (id tactical_scheme)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Матчи
class Match < ActiveRecord::Base
  include SeoMixin
  acts_as_votable_for_match
  attr_accessible   :title,
                    :content,
                    :count_home,
                    :count_guest,
                    :referee_id,
                    :is_published,
                    :is_deleted,
                    :is_comments_enabled,
                    :leagues_group_id,
                    :team_home_id,
                    :team_guest_id,
                    :date_at,
                    :start_at,
                    :finish_at,
                    :team_home_scheme_id,
                    :team_guest_scheme_id,
                    :is_show_in_sidebar,
                    :side,
                    :stage,
                    :position_in_stage

  belongs_to :team_home, class_name: "Team", foreign_key: :team_home_id
  belongs_to :team_guest, class_name: "Team", foreign_key: :team_guest_id

  belongs_to :leagues_group

  # Связь с судьей
  belongs_to :referee, class_name: "Person", foreign_key: :referee_id

  has_many :broadcast_messages
  has_many :events
  has_many :team_formations

  # Validations
  # ================================================================
  validates :team_home_id, :team_guest_id, :date_at, presence: true

  # Scopes
  # ================================================================
  scope :not_deleted,         ->(){ where('is_deleted = 0') }
  scope :is_published,        ->(){ where("is_published = 1 AND is_deleted = 0") }
  scope :last_matches,        ->(){ where("date_at <= utc_timestamp() and count_home is not null AND count_guest is not null") }
  scope :by_category,         ->(category){ where("category_id = ?", category) }
  scope :played_matches,      ->(ids){ where("count_home IS NOT NULL AND count_guest IS NOT NULL AND leagues_group_id IN (?)", ids).order('date_at DESC, finish_at DESC') }

  after_save :update_leagues_statistics
  before_save :update_show_in_sidebar

  def update_show_in_sidebar
    if is_show_in_sidebar_changed?
      sql = 'UPDATE matches SET is_show_in_sidebar = 0'
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  # Callback, который обновляет статистику группового турнира
  # Если команда выиграла, ей добавляется 3 очка
  # Если команды сыграли в ничью, они получают по 1 очку
  # Если команда проиграла, она не получает очков
  #
  # TODO 3 очка для футбола, для хоккея нужно переделать на 2 очка
  # http://ru.wikipedia.org/wiki/Правило трёх очков за победу
  #
  # TODO Обновлять только заторнутые команды, а не всю турнирную таблицу
  #
  # @return [true]
  #
  def update_leagues_statistics
    #  matches          :integer          default(0), not null  # (И) Сыгранно матчей
    #  matches_win      :integer          default(0), not null  # (В) Выиграно матчей
    #  matches_draw     :integer          default(0), not null  # (Н) Матчей сыгранных в ничью
    #  matches_fail     :integer          default(0), not null  # (П) Проигранно матчей
    #  goals_win        :integer          default(0), not null  # (ЗМ) Забито мячей/шайб
    #  goals_fail       :integer          default(0), not null  # (ПМ) Пропущено мячей/шайб
    #  goals_diff       :integer          default(0), not null  # (РМ) Разница в мячах/шайбах
    #  points           :integer          default(0), not null  # (O) Очки

    points = {}
    matches = {}
    matches_win = {}
    matches_fail = {}
    matches_draw = {}
    goals_win = {}
    goals_fail = {}
    teams = Set.new

    return if leagues_group.nil?
    return if leagues_group.matches.nil?

    leagues_group.matches.each do |match|

      home_id = match.team_home_id
      guest_id = match.team_guest_id

      # Если команды не играли - пропускаем запись
      # next if match.count_home.nil? || match.count_guest.nil?

      # Регистрируем команды
      teams << home_id
      teams << guest_id

      if match.count_home.present? && match.count_guest.present?
        # Матчи
        matches[home_id] = matches[home_id].to_i + 1
        matches[guest_id] = matches[guest_id].to_i + 1

        # Забито мячей/шайб
        goals_win[home_id] = goals_win[home_id].to_i + match.count_home.to_i
        goals_win[guest_id] = goals_win[guest_id].to_i + match.count_guest.to_i

        # Пропущено мячей/шайб
        goals_fail[home_id] = goals_fail[home_id].to_i + match.count_guest.to_i
        goals_fail[guest_id] = goals_fail[guest_id].to_i + match.count_home.to_i

        # Выигрывает принимающая команда
        if match.count_home > match.count_guest

          points[home_id] = points[home_id].to_i + 3
          matches_win[home_id] = matches_win[home_id].to_i + 1
          matches_fail[guest_id] = matches_fail[guest_id].to_i + 1

        # Выигрывает команда в гостях
        elsif match.count_home < match.count_guest

          points[guest_id] = points[guest_id].to_i + 3
          matches_win[guest_id] = matches_win[guest_id].to_i + 1
          matches_fail[home_id] = matches_fail[home_id].to_i + 1

        # Ничья
        elsif match.count_home == match.count_guest

          points[home_id] = points[home_id].to_i + 1
          points[guest_id] = points[guest_id].to_i + 1
          matches_draw[home_id] = matches_draw[home_id].to_i + 1
          matches_draw[guest_id] = matches_draw[guest_id].to_i + 1

        end
      end

    end

    teams.each do |team_id|
      stat = LeaguesStatistic.find_or_create_by_leagues_group_id_and_team_id(leagues_group.id, team_id)
      stat.year_id       = leagues_group.year.id
      stat.matches       = matches[team_id]
      stat.matches_win   = matches_win[team_id]
      stat.matches_draw  = matches_draw[team_id]
      stat.matches_fail  = matches_fail[team_id]
      stat.goals_win     = goals_win[team_id]
      stat.goals_fail    = goals_fail[team_id]
      if goals_win[team_id].present? && goals_fail[team_id].present?
        stat.goals_diff  = goals_win[team_id] - goals_fail[team_id]
      else
        stat.goals_diff  = nil
      end
      stat.points        = points[team_id]
      stat.save!
    end
  end

  # Название матча
  #
  # @return [String] название матча
  #
  def title
    @title = super
    @title.blank? ? "Матч #{team_home.title} - #{team_guest.title}" : @title
  end

  def self.for_sidebar
    where(is_show_in_sidebar: true).first
  end

  def self.any_for_sidebar?
    where(is_show_in_sidebar: true).any?
  end

  # Парсит матчи в JSON
  #
  # @param mathes   [Array] массив матсей
  # @return matches [JSON]  JSON массив матчей
  #
  def self.parse_to_json(matches)
    matches.map do |match|
      {
        weekday: match.start_at.present? ? Russian::strftime(match.start_at, '%a') : '',
        day: match.start_at.present? ? match.start_at.strftime("%d.%m") : '',
        team_home_title: match.team_home.title,
        team_guest_title: match.team_guest.title,
        match_count_home: match.count_home,
        match_count_guest: match.count_guest
      }
    end
  end

  def hits(date = nil)
    Statistics::Visits::hits(self.id, self.class.name, date)
  end

  def teams_ids
    [team_guest_id, team_home_id]
  end

  def teams
    Team.where(id: teams_ids)
  end

  def formations_hash
    teams.each_with_object({}) do |team, result|
      formations = team.team_formations.includes(:person).where(match_id: id)
      result[team.id] = {
        id:    team.id,
        title: team.title,
        # coach: team.coach,
        side:  team.id == team_home_id ? 'home' : 'guest',
        reserve:   formations.where(person_type: TeamFormation::TEAM_FORMATION_KEYS[:reserve]).map { |player| player.to_hash :backbone },
        formation: formations.where('person_type != ?', TeamFormation::TEAM_FORMATION_KEYS[:reserve]).map { |player| player.to_hash :backbone }.group_by { |player| player[:type] }
      }
    end
  end

  def players
    Person.joins(:teams_persons).where(teams_persons: { team_id: teams_ids })
  end

  def time_elapsed
    start_at
  end

  def to_hash
    {
      messages: broadcast_messages.includes(event: [:team, :player]).map(&:to_hash),
      formations: formations_hash
    }
  end

  def to_json(target = nil)
    return super if target.nil?
    case target
    when :api then to_hash.to_json
    else super
    end
  end
end
