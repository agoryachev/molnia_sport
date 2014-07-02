# encoding: utf-8
class AddTeamIdToLeaguesStatistics < ActiveRecord::Migration
  def change
    add_column :leagues_statistics, :team_id, :integer, after: :group_id, null: false, comment: 'Внешний ключ для связи с таблицей команд'
  end
end