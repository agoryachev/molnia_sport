# encoding: utf-8
class RemoveTitleFromInsides < ActiveRecord::Migration
  def change
    remove_column :insides, :title
  end
end
