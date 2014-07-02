# encoding: utf-8
class AddCommentToCategoryIdInLeagues < ActiveRecord::Migration
  def change
    set_column_comment :leagues, :category_id, "Внешний ключ для связи с категорией"
  end
end
