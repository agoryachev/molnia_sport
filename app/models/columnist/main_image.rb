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

class Columnist::MainImage < MediaFile
  attr_accessible :file
  belongs_to :columnist, foreign_key: :media_file_id
  
  has_attached_file :file,
                    storage: :sftp,
                    sftp_options: {
                     host: FILE_STORAGE['sftp']['host'],
                     user: FILE_STORAGE['sftp']['user'],
                     password: FILE_STORAGE['sftp']['password'],
                    paranoid: false
                    },   
                    processor: 'mini_magick',
                    path: "#{FILE_STORAGE['sftp']['path']}/media/columnists/:parent_id/:basename_:style.:extension",
                    url: "#{FILE_STORAGE['sftp']['url']}/media/columnists/:parent_id/:basename_:style.:extension",
                    styles: { 
                      _70x70: { geometry: '',
                                  convert_options: '-gravity center -resize "70x70^" -crop "70x70+0+0" +repage'
                      },
                      _90x90:   { geometry: '',
                                  convert_options: '-gravity center -resize "90x90^" -crop "90x90+0+0" +repage'
                      },
                      _68x68:   { geometry: '',
                                  convert_options: '-gravity center -resize "68x68^" -crop "68x68+0+0" +repage'
                      },
                      thumb:    {
                                  geometry: '',
                                  convert_options: '-gravity center -resize "100x100^" -crop "100x100+0+0" +repage'
                      }
                    },
                    default_url: "missing/post_:style.jpg"


  validates_attachment_content_type :file, content_type: [ /^image\/(?:jpg|jpeg|gif|png)$/, nil ], message: "Неподдерживаемый тип файла"   
  validates_attachment_size :file, less_than: Setting.backend_max_uploaded_image_size.megabytes, message: "Размер изображения слишком большой" 
  before_post_process :randomize_file_name
end
