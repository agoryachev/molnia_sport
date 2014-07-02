# encoding: utf-8
class AddSubtitleToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :subtitle, :string, comment: 'Подзаголовок', after: :title
  end
end
