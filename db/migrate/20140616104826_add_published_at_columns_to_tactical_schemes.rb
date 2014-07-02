# encoding: utf-8
class AddPublishedAtColumnsToTacticalSchemes < ActiveRecord::Migration
  def change
    add_column :tactical_schemes, :published_at, :datetime, null: false, comment: "Дата и время публикации"
  end
end
