# encoding: utf-8
class AddIdWatermark < ActiveRecord::Migration
  def change
    add_column :galleries, :is_exclusive, :boolean, null: false, default: 0, after: :is_comments_enabled, comment: 'Эксклюзивный материал, изображения защищаются водяным знаком'
    add_column :posts, :is_exclusive, :boolean, null: false, default: 0, after: :is_comments_enabled, comment: 'Эксклюзивный материал, изображения защищаются водяным знаком'
  end
end
