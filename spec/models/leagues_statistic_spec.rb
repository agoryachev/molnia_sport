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

require 'spec_helper'

describe LeaguesStatistic do
  let(:leagues_statistic) { FactoryGirl.create(:leagues_statistic) }

  subject { leagues_statistic }

  context 'отвечает и валидно' do 
    it { should respond_to(:year_id) }
    it { should respond_to(:leagues_group_id) }
    it { should respond_to(:team_id) }
    it { should respond_to(:matches) }
    it { should respond_to(:matches_win) }
    it { should respond_to(:matches_draw) }
    it { should respond_to(:matches_fail) }
    it { should respond_to(:goals_win) }
    it { should respond_to(:goals_fail) }
    it { should respond_to(:goals_diff) }
    it { should respond_to(:points) }

    it { should respond_to(:year) }
    it { should respond_to(:leagues_group) }
    it { should respond_to(:team) }

    it { should belong_to(:year) }
    it { should belong_to(:leagues_group) }
    it { should belong_to(:team) }

    it { should be_valid }
  end
end
