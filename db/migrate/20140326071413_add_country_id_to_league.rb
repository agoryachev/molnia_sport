# encoding: utf-8
class AddCountryIdToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :country_id, :integer, default: 0, comment: 'Связь со странами'
  end
end
