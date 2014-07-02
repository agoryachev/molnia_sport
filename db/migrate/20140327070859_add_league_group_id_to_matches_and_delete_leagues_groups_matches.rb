# encoding: utf-8
class AddLeagueGroupIdToMatchesAndDeleteLeaguesGroupsMatches < ActiveRecord::Migration
  def change
    drop_table :leagues_groups_matches
    add_column :matches, :leagues_group_id, :integer, comment: 'Связь с таблицей группы'
  end
end
