# encoding: utf-8
class AddDefaultValueCommentsCount < ActiveRecord::Migration
  def change
    change_column :comments, :cached_weighted_score, :integer, default: 0
    set_column_comment :comments, :cached_weighted_score, 'количество голосов'
  end
end