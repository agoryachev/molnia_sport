# encoding: utf-8
class AddCategoryIdToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :category_id, :integer, after:"id"
    add_index :leagues, :category_id
  end
end
