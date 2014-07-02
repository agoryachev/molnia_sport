# encoding: utf-8
class CreateColumnistPosts < ActiveRecord::Migration
  def change
    create_table :columnist_posts, comment: 'Заметки колумнистов' do |t|

      t.string   :title,    null: false, comment: "Заголовок заметки"
      t.string   :subtitle, null: true,  comment: "Подзаголовок заметки"
      t.text     :content,  null: false, comment: "Содержимое заметки"

      t.integer  :category_id,  unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей разделов"
      t.integer  :employee_id,  unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей сотрудников"
      t.integer  :columnist_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей колумнистов"

      t.boolean  :is_published,        unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean  :is_deleted,          unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean  :is_comments_enabled, unsigned: true, null: false, default: true,  comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"
      t.boolean  :delta,               unsigned: true, null: false, default: true,  comment: "Индекс для полнотекстового поиска (Sphinx)"

      t.integer  :comments_count,      unsigned: true, null: false, default: 0,     comment: "Количество комментариев к новости"

      t.datetime :published_at, null: false, comment: "Дата и время публикации"

      t.timestamps
    end
  end
end
