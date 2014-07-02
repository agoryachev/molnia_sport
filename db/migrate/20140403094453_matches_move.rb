# encoding: utf-8
class MatchesMove < ActiveRecord::Migration
  def change
    change_column :matches, :title, :string, after: :team_guest_id
    set_column_comment :matches, :title, 'Название матча'
  end
end