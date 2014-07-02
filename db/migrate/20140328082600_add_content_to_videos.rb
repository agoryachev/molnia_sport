# encoding: utf-8
class AddContentToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :content, :text, after: 'title', comment: 'Описание видео-ролика'
  end
end