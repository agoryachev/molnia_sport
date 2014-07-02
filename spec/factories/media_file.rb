# encoding: utf-8
# == Schema Information
#
# Table name: media_files # Медиа-файлы (фото-, видео-файлы)
#
#  id                :integer          not null, primary key
#  media_file_id     :integer                                # Идентификатор таблицы связанной модели (Post, Video, GalleryPhoto)
#  title             :string(255)                            # Заголовок файла
#  description       :string(255)                            # Описание файла
#  properties        :string(2000)                           # Сериализованное поле для хранения свойст файла(duration, width, height)
#  class_name        :string(255)      default(""), not null # Название метода обработчика комментария GalleryPhoto::File Video::Clip Video::Frame
#  file_file_path    :string(255)                            # Путь до файла
#  file_file_name    :string(255)      not null              # Путь к файлу (paperclip)
#  file_content_type :string(255)                            # MEDIA-тип файла (paperclip)
#  file_file_size    :integer                                # Размер файла в байтах (paperclip)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryGirl.define do
  factory :media_file do

    media_file_id           1
    class_name              "Post::MainImage"
    file_file_name          "test.jpg"
    file_content_type       "image/jpeg"
    file_file_size          0

  end
end