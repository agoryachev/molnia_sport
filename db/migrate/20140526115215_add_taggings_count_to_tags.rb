# encoding: utf-8
class AddTaggingsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :taggings_count, :integer, comment: 'Количество тегов'
  end
end
