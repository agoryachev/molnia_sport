# encoding: utf-8
class AddCountryIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :country_id, :integer, after: :is_comments_enabled, comment: 'Связь со странами'
  end
end