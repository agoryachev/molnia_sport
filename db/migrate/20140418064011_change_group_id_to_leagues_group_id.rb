# encoding: utf-8
class ChangeGroupIdToLeaguesGroupId < ActiveRecord::Migration
  def change
    rename_column :leagues_statistics, :group_id, :leagues_group_id
    set_column_comment :leagues_statistics, :leagues_group_id, 'Добавляем возможность вести статистику в рамках подгруппы'
  end
end