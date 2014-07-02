# encoding: utf-8
class CreateCounterMediaPublications < ActiveRecord::Migration
  def change

    create_table :counter_media_publications, comment: "Промежуточная таблица для связи файлов медиа библиотеки с публикациями (новости, блоги и т.д.)" do |t|
      t.string   :publication_type, null: false, comment: "Тип публикации(Post, MediaFile)"
      t.integer  :publication_id, unsigned: true, null: false, comment: "Внешний ключ для связи с опубликованным материалом (Post, BlogPost)"
      t.integer  :media_file_id, unsigned: true, null: false, comment: "Внешний ключ для связи с медиабиблиотекой"
    end

    add_index :counter_media_publications, [:media_file_id]
    add_index :counter_media_publications, [:publication_id, :publication_type], length: {publication_type: 10}, name: 'publication_id_and_publication_type'

  end
end