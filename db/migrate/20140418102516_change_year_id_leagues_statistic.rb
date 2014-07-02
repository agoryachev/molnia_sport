# encoding: utf-8
class ChangeYearIdLeaguesStatistic < ActiveRecord::Migration
  def change
    change_column :leagues_statistics, :year_id, :integer, null: true
    set_column_comment :leagues_statistics, :year_id, 'Год/Сезон проведения турнира'
  end
end