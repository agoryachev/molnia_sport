# encoding: utf-8
class PostsStatus < ActiveRecord::Migration
  def change

    create_table :post_statuses, force: true, comment: "Статус новостей (инфографика, live из Бразилии, стадионы, судьи)" do |t|

      t.string    :title, null: false, default: "", comment: "Статус"
      t.string    :color, null: true, default: "red_page", comment: "Цвет статуса"
      t.string    :image, null: true, comment: "Путь к изображению, которое накладывается на главное изображение"

    end

  end
end