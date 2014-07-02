# encoding: utf-8
class AddPublishedAtToTweetsAndInstagram < ActiveRecord::Migration
  def change
    add_column :tweets,            :published_at, :datetime, null: false, comment: "Дата и время публикации"
    add_column :instagram_records, :published_at, :datetime, null: false, comment: "Дата и время публикации"
  end
end
