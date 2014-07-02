# encoding: utf-8
class RenamePublicationAuthor < ActiveRecord::Migration

  def change
    rename_column :authors_publications, :publication_type, :authorable_type
    rename_column :authors_publications, :publication_id, :authorable_id
    set_column_comment :authors_publications, :authorable_type, "Тип связанной публикации (Post, Video, Gallery)"
    set_column_comment :authors_publications, :authorable_id, "Внешний ключ для связи с публикацией (Post, Video, Gallery)"
  end

end