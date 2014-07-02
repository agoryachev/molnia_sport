# encoding: utf-8
class AddFileFilePathToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :file_file_path, :string, after: :class_name, comment: 'Путь до файла'
  end
end
