# encoding: utf-8
class AddYearIdToLeaguesGroups < ActiveRecord::Migration
  def change
    add_column :leagues_groups, :year_id, :integer, comment: 'Связть с таблицей года'
  end
end
