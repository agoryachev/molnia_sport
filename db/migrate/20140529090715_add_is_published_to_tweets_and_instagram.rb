# encoding: utf-8
class AddIsPublishedToTweetsAndInstagram < ActiveRecord::Migration
  def change
    add_column :tweets,            :is_published, :boolean, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
    add_column :instagram_records, :is_published, :boolean, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
  end
end
