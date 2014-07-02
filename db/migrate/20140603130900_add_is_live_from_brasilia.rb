# encoding: utf-8
class AddIsLiveFromBrasilia < ActiveRecord::Migration
  def change
    add_column :posts, :is_live_from_brasilia, :boolean, default: false, null: false, after: :is_infograph, comment: "1 - помечено как 'Live из Бразили' (водяной знако на главное изображение), 0 - обычная новость"
  end
end
