# encoding: utf-8
class AdditionalFieldsToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :title, :string, after: :media_file_id, comment: 'Заголовок файла'
    add_column :media_files, :description, :string, after: :title, comment: 'Описание файла'
    add_column :media_files, :properties, :string, limit: 2000, after: :description, comment: 'Сериализованное поле для хранения свойст файла(duration, width, height)'
  end
end