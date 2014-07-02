# -*- coding: utf-8 -*-
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

class MediaFile::Image < MediaFile
  attr_accessible :file

  has_attached_file :file,
                    storage: :sftp,
                    sftp_options: {
                      host: FILE_STORAGE['sftp']['host'],
                      user: FILE_STORAGE['sftp']['user'],
                      password: FILE_STORAGE['sftp']['password'],
                      paranoid: false
                    },   
                    processor: 'mini_magick',
                    path: "#{FILE_STORAGE['sftp']['path']}/:custom_path/:basename.:extension",
                    url: "#{FILE_STORAGE['sftp']['url']}/:custom_path/:basename.:extension",                
                    styles: {
                      thumb:
                        {
                          geometry: '',
                          convert_options: '-gravity north -resize "100x100^" -crop "100x100+0+0" +repage'
                        }
                      }
  validates_attachment_content_type :file, content_type: [ /^image\/(?:jpg|jpeg|gif|png)$/, nil ], message: "Неподдерживаемый тип файла"
  validates_attachment_size :file, less_than: Setting.backend_max_uploaded_image_size.megabytes, message: "Объем файла изображения слишком велик" 
  before_post_process :randomize_file_name 

end
