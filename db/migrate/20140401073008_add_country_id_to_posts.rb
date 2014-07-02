# encoding: utf-8
class AddCountryIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :country_id, :integer, comment: 'Связь со странами'
  end
end
