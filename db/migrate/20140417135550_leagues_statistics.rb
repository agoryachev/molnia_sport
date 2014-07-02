# encoding: utf-8
class LeaguesStatistics < ActiveRecord::Migration
  def change
    create_table :leagues_statistics, comment: "Турнирная таблица" do |t|
      t.integer  :year_id, unsigned: true, null: false, comment: "Год/сезон проведения турнира"
      t.integer  :group_id, unsigned: true, null: true, comment: "Добавляем возможность вести статистику в рамках подгруппы"
      t.integer  :matches, unsigned: true, null: false, default: 0, comment: "(И) Сыгранно матчей"
      t.integer  :matches_win, unsigned: true, null: false, default: 0, comment: "(В) Выиграно матчей"
      t.integer  :matches_draw, unsigned: true, null: false, default: 0, comment: "(Н) Матчей сыгранных в ничью"
      t.integer  :matches_fail, unsigned: true, null: false, default: 0, comment: "(П) Проигранно матчей"
      t.integer  :goals_win, unsigned: true, null: false, default: 0, comment: "(ЗМ) Забито мячей/шайб"
      t.integer  :goals_fail, unsigned: true, null: false, default: 0, comment: "(ПМ) Пропущено мячей/шайб"
      t.integer  :goals_diff, null: false, default: 0, comment: "(РМ) Разница в мячах/шайбах"
      t.integer  :points, unsigned: true, null: false, default: 0, comment: "(O) Очки"
    end
  end
end