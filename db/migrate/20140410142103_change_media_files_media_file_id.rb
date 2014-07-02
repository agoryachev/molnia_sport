# encoding: utf-8
class ChangeMediaFilesMediaFileId < ActiveRecord::Migration
  def change
    change_column :media_files, :media_file_id, :integer, null: true
    set_column_comment :media_files, :media_file_id, 'Идентификатор таблицы связанной модели (Post, Video, GalleryPhoto)'
  end
end