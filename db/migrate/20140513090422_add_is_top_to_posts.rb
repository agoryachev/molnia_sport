# encoding: utf-8
class AddIsTopToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_top, :boolean, after: :is_exclusive, default: false, null: false, comment: '1 - Новость выводится в TOP-новостях, 0 - не выводится'
  end
end
