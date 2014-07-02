# encoding: utf-8
class CommentCategories < ActiveRecord::Migration
  def change
    set_table_comment :countries, "Страна, входит в состав категории (category), содержит лиги/чемпионаты (league)"
  end
end