class CreateCommentsComments < ActiveRecord::Migration
  def change
    create_table :comments, force: true do |t|
      t.string :title
      t.text :content
      t.integer :commentable_id
      t.string  :commentable_type
      t.integer :user_id
      t.boolean :is_published
      t.boolean :is_deleted
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth
      t.integer :cached_weighted_score

      t.timestamps
    end

    add_index  :comments, :cached_weighted_score
    add_index :comments, [:user_id]
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
