# encoding: utf-8
class RemovePlacementIndexFromCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :placement_index
  end
end
