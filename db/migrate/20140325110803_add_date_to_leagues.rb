# encoding: utf-8
class AddDateToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :date, :date, comment: 'год проведения турнира'
  end
end
