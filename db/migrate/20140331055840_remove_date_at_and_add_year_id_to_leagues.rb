# encoding: utf-8
class RemoveDateAtAndAddYearIdToLeagues < ActiveRecord::Migration
  def change
    remove_column :leagues, :date_at
  end
end
