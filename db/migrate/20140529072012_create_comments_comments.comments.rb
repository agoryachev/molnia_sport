# encoding: utf-8
# This migration comes from comments (originally 20140510171516)
class CreateCommentsComments < ActiveRecord::Migration
  def change
    drop_table :comments
    create_table :comments, force: true do |t|
      t.text :content, comment: 'Комментарий'
      t.integer :commentable_id, comment: 'Полиморфная связь'
      t.string  :commentable_type, comment: 'Полиморфная связь'
      t.integer :user_id, comment: 'Связь с таблицей пользователя'
      t.boolean :is_published, comment: '1-опубликовано, 0-не опубликовано'
      t.boolean :is_deleted, comment: '1-удалено, 0-не удалено'
      t.integer :lft, comment: 'левая граница nested set'
      t.integer :rgt, comment: 'правая граница nested set'
      t.integer :parent_id, comment: 'родитель коментария'
      t.integer :depth, comment: 'глубина nested set'
      t.integer :cached_weighted_score, comment: 'количество голосов'

      t.timestamps
    end

    add_index :comments, :cached_weighted_score
    add_index :comments, [:user_id]
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
