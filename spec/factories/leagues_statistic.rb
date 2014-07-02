# encoding: utf-8
# == Schema Information
#
# Table name: leagues_statistics # Турнирная таблица
#
#  id               :integer          not null, primary key
#  year_id          :integer          not null              # Год/сезон проведения турнира
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
FactoryGirl.define do
  factory :leagues_statistic do

    year_id               1
    leagues_group_id      1
    team_id               1
    matches               1
    matches_win           1
    matches_draw          1
    matches_fail          1
    goals_win             1
    goals_fail            1
    goals_diff            1
    points                1

  end
end