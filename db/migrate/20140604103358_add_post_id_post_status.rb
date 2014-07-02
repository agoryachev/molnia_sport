# encoding: utf-8
class AddPostIdPostStatus < ActiveRecord::Migration
  def change
    add_column :posts, :post_status_id, :integer, null: true, after: :is_exclusive, comment: "Внешний ключ, для связи с таблицей статусов"
  end
end