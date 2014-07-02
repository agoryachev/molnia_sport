# encoding: utf-8
class AddCommentsCountToPagesMatches < ActiveRecord::Migration
  def change
    add_column :pages, :comments_count, :integer, default: 0, comment: 'Количество комментариев к странице'
    add_column :matches, :comments_count, :integer, default: 0, comment: 'Количество комментариев к матчам'
  end
end
