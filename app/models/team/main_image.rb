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

class Team::MainImage < MediaFile
  attr_accessible :file
  belongs_to :team, foreign_key: :media_file_id
  
  has_attached_file :file,
                    storage: :sftp,
                    sftp_options: {
                     host: FILE_STORAGE['sftp']['host'],
                     user: FILE_STORAGE['sftp']['user'],
                     password: FILE_STORAGE['sftp']['password'],
                    paranoid: false
                    },   
                    processor: 'mini_magick',
                    path: "#{FILE_STORAGE['sftp']['path']}/media/teams/:parent_id/:basename_:style.:extension",
                    url: "#{FILE_STORAGE['sftp']['url']}/media/teams/:parent_id/:basename_:style.:extension",
                    styles: {
                      _150x150: { geometry: '',
                                  convert_options: '-gravity center -resize "150x150^" -crop "150x150+0+0" +repage'
                      },
                      _102x69:   { geometry: '',
                                  convert_options: '-gravity center -resize "102x69^" -crop "102x69+0+0" +repage'
                      },
                      _90x90:   { geometry: '',
                                  convert_options: '-gravity center -resize "90x90^" -crop "90x90+0+0" +repage'
                      },
                      _65x65:   { geometry: '',
                                  convert_options: '-gravity center -resize "65x65^" -crop "65x65+0+0" +repage'
                      },
                      _70x40:   { geometry: '',
                                  convert_options: '-gravity center -resize "70x40^" -crop "70x40+0+0" +repage'
                      },
                      _38x22:   { geometry: '',
                                  convert_options: '-gravity center -resize "38x22^" -crop "38x22+0+0" +repage'
                      },
                      _35x20:   { geometry: '',
                                  convert_options: '-gravity center -resize "35x20^" -crop "35x20+0+0" +repage'
                      },
                      _30x17:   { geometry: '',
                                  convert_options: '-gravity center -resize "30x17^" -crop "30x17+0+0" +repage'
                      },
                      _22x13:   { geometry: '',
                                  convert_options: '-gravity center -resize "22x13^" -crop "22x13+0+0" +repage'
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
