# encoding: utf-8
class AddIsDeletedToTweetsAndInstagrams < ActiveRecord::Migration
  def change
    add_column :tweets,            :is_deleted, :boolean, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
    add_column :instagram_records, :is_deleted, :boolean, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
  end
end
