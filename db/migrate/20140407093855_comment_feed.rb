# encoding: utf-8
class CommentFeed < ActiveRecord::Migration
  def change
    set_table_comment :feeds, "Лента со всеми материалами: Новости, Галлереи и Видео"
  end
end