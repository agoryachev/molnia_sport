# encoding: utf-8
class ChangeIsPublishedMatches < ActiveRecord::Migration
  def change
    change_column :matches, :is_published, :boolean, null: true, default: true
    set_column_comment :matches, :is_published, '1 - опубликовано (отображается), 0 - не опубликовано (не отображается)'
  end
end