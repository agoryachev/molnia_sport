# encoding: utf-8
class AddTitleToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :title, :string, comment: 'Название матча'
  end
end
