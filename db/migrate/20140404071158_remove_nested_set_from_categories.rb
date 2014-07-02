# encoding: utf-8
class RemoveNestedSetFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :parent_id
    remove_column :categories, :lft
    remove_column :categories, :rgt
    remove_column :categories, :depth
  end
end