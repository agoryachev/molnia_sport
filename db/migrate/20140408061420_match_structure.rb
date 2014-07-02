# encoding: utf-8
class MatchStructure < ActiveRecord::Migration
  def change
    change_column :matches, :leagues_group_id, :integer, after: :team_guest_id
    set_column_comment :matches, :leagues_group_id, 'Связь с таблицей группы'
  end
end