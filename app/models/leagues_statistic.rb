# encoding: utf-8
# == Schema Information
#
# Table name: leagues_statistics # Турнирная таблица
#
#  id               :integer          not null, primary key
#  year_id          :integer                                # Год/Сезон проведения турнира
#  leagues_group_id :integer                                # Добавляем возможность вести статистику в рамках подгруппы
#  team_id          :integer          not null              # Внешний ключ для связи с таблицей команд
#  matches          :integer          default(0), not null  # (И) Сыгранно матчей
#  matches_win      :integer          default(0), not null  # (В) Выиграно матчей
#  matches_draw     :integer          default(0), not null  # (Н) Матчей сыгранных в ничью
#  matches_fail     :integer          default(0), not null  # (П) Проигранно матчей
#  goals_win        :integer          default(0), not null  # (ЗМ) Забито мячей/шайб
#  goals_fail       :integer          default(0), not null  # (ПМ) Пропущено мячей/шайб
#  goals_diff       :integer          default(0), not null  # (РМ) Разница в мячах/шайбах
#  points           :integer          default(0), not null  # (O) Очки
#

class LeaguesStatistic < ActiveRecord::Base
  attr_accessible :year_id,
                  :leagues_group_id,
                  :team_id,
                  :matches,
                  :matches_win,
                  :matches_draw,
                  :matches_fail,
                  :goals_win,
                  :goals_fail,
                  :goals_diff,
                  :points

  belongs_to :year
  belongs_to :leagues_group
  belongs_to :team


  # TODO перепесать этот метод так как он перекрывает этот же метов
  # в ActiveRecord

  # Возвращает или создает объект по идентификатору группы лиги и команды
  #
  # @param leagues_group_id [Integer] идентификатор группы лиги
  # @param team_id [Integer] идентификатор команды
  # @return [LeaguesStatistic]
  #
  def self.find_or_create_by_leagues_group_id_and_team_id(leagues_group_id, team_id)
    obj = self.find_by_leagues_group_id_and_team_id(leagues_group_id, team_id) ||
          self.new(leagues_group_id: leagues_group_id, team_id: team_id)
    obj.save
    obj
  end

  # Получение статистики по лиге
  #
  # @param league_id [Integer] id лиги, по которой надо получить статистику
  # @param year_id   [Integer] id года по которому надо отфильтровать
  # @return [Array] статистика по лиге
  #
  def self.get_statistics_for_league(league_id, year_id)
    tmp = select("
      teams.title as team_title,
      SUM(matches) as sum_matches,
      SUM(matches_win) as sum_matches_win,
      SUM(matches_draw) as sum_matches_draw,
      SUM(matches_fail) as sum_matches_fail,
      SUM(goals_win) as sum_goals_win,
      SUM(goals_fail) as sum_goals_fail,
      SUM(points) as sum_points,
      SUM(goals_diff) as sum_goals_diff
    ")
    .where("
      leagues_group_id 
        IN (SELECT id FROM leagues_groups WHERE league_id = ?)
    ", league_id)
    tmp = tmp.where("year_id = ?", year_id) if year_id.present?
    tmp
    .joins("JOIN teams ON teams.id = leagues_statistics.team_id")
    .order("sum_points DESC")
    .order("sum_goals_win DESC")
    .order("sum_goals_fail DESC")
    .group(:team_id)
  end

end
