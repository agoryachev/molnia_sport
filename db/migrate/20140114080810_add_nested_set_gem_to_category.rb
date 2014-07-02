# encoding: utf-8
class AddNestedSetGemToCategory < ActiveRecord::Migration
  def change
    drop_table :categories
    create_table :categories do |t|
      t.string    :title, null: false, default: "", comment: "Заголовок категории"
      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.integer   :placement_index, unsigned: true, null: false, default: 0, comment: "Поле для задания порядка следования категорий на одном уровне относительно друг друга"
      t.integer   :parent_id, unsigned: true, comment: "Родитель id"
      t.integer   :lft, unsigned: true, null: false, default: 0, comment: "Левый индекс Nested Set для дерева категорий"
      t.integer   :rgt, unsigned: true, null: false, default: 0, comment: "Правый индекс Nested Set для дерева категорий"
      t.integer   :depth, unsigned: true, null: false, default: 0, comment: "Глубина в рамках дерева категорий Nested Set"
    end
    add_index :categories, :lft
    add_index :categories, :rgt
    add_index :categories, :depth
    add_index :categories, :parent_id
  end
end
