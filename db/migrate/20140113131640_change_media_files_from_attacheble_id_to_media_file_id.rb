# encoding: utf-8
class ChangeMediaFilesFromAttachebleIdToMediaFileId < ActiveRecord::Migration
  def change
    # Нам эти позиции в этом проекте не нужны, так как мы отображаем авторов, а не сотрудников
    remove_column :employees, :is_published
    remove_column :employees, :description
    remove_column :employees, :position
    remove_column :employees, :placement_index
    remove_column :employees, :show_publications

    # Переименовываем ключ
    rename_column :media_files, :attachable_id, :media_file_id
    set_column_comment :media_files, :media_file_id, "Идентификатор таблицы связанной модели (Post, Video, GalleryPhoto)"
  end

end
