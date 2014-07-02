# encoding: utf-8
class AddIsInfographToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_infograph, :boolean, default: false, null: false, after: :is_exclusive, comment: "1 - помечено как инфографика (водяной знако на главное изображение), 0 - обычная новость"
  end
end