# encoding: utf-8
class AddTacticalShemesIdsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :team_home_scheme_id, :integer, null: true,  comment: 'Предматчевая расстановка хозяев'
    add_column :matches, :team_guest_scheme_id, :integer, null: true, comment: 'Предматчевая расстановка гостей'
  end
end
