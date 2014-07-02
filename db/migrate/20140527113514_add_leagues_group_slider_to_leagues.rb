# encoding: utf-8
class AddLeaguesGroupSliderToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :is_leagues_group_slider, :boolean, default: false, after: :is_comments_enabled, comment: '1 - показывать в слайдере, 0 - нет'
  end
end
