# encoding: utf-8
class LeaguesGroupsMoveYearId < ActiveRecord::Migration
  def change
    change_column :leagues_groups, :year_id, :integer, after: :league_id
    set_column_comment :leagues_groups, :year_id, 'Внешний ключ для связи с годами'

    change_column :posts, :country_id, :integer, after: :employee_id
    set_column_comment :posts, :country_id, 'Внешний ключ для связи со странами'
  end
end