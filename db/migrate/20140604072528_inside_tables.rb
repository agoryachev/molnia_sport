# encoding: utf-8
class InsideTables < ActiveRecord::Migration
  def change

    create_table :insides, force: true, comment: "Инсайд-новости (трансферные слухи)" do |t|

      t.string    :title, null: false, default: "", comment: "Заголовок новости"
      t.text      :content, null: false, comment: "Содержимое новости"
      t.string    :source, null: true, default: "", comment: "Источник"

      t.integer   :person_id, null: true, comment: "Внешний ключ для связи с персоной, к которой относятся слухи"
      t.integer   :inside_status_id, null: true, comment: "Внешний ключ для связи со статусом новости (слухи, переговоры, официально и т.п.)"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"

      t.datetime  :published_at, unsigned: true, null: true, comment: "Дата и время публикации новости"

      t.timestamps

    end

    create_table :inside_statuses, force: true, comment: "Статус инсайд-новостей (трансферных слухов)" do |t|

      t.string    :title, null: false, default: "", comment: "Статус"
      t.string    :color, default: "red_page", comment: "Цвет статуса"

    end

  end
end