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

class Post::MainImage < MediaFile
  attr_accessible :file
  belongs_to :post, foreign_key: :media_file_id
  
  has_attached_file :file,
                    storage: :sftp,
                    sftp_options: {
                     host: FILE_STORAGE['sftp']['host'],
                     user: FILE_STORAGE['sftp']['user'],
                     password: FILE_STORAGE['sftp']['password'],
                    paranoid: false
                    },   
                    processor: 'mini_magick',
                    path: "#{FILE_STORAGE['sftp']['path']}/media/posts:date_to_path/:parent_id/:basename_:style.:extension",
                    url: "#{FILE_STORAGE['sftp']['url']}/media/posts:date_to_path/:parent_id/:basename_:style.:extension",                
                    styles: { 
                      _620x345: { geometry: '',
                                  convert_options: '-gravity center -resize "620x345^" -crop "620x345+0+0" +repage'
                      },
                      _620x380: { geometry: '',
                                  convert_options: '-gravity center -resize "620x380^" -crop "620x380+0+0" +repage'
                      },
                      _300x200: { geometry: '',
                                  convert_options: '-gravity center -resize "300x200^" -crop "300x200+0+0" +repage'
                      },
                      _200x112: { geometry: '',
                                  convert_options: '-gravity center -resize "200x112^" -crop "200x112+0+0" +repage'
                      },
                      _358x219: { geometry: '',
                        convert_options: '-gravity center -resize "358x219^" -crop "358x219+0+0" +repage'
                      },
                      _206x115: { geometry: '',
                        convert_options: '-gravity center -resize "206x115^" -crop "206x115+0+0" +repage'
                      },
                      _178x159: { geometry: '',
                                  convert_options: '-gravity center -resize "178x159^" -crop "178x159+0+0" +repage'
                      },
                      _171x115: { geometry: '',
                                  convert_options: '-gravity center -resize "171x115^" -crop "171x115+0+0" +repage'
                      },
                      _194x147: { geometry: '',
                                  convert_options: '-gravity center -resize "194x147^" -crop "194x147+0+0" +repage'
                      },
                      _105x70:  { geometry: '',
                                  convert_options: '-gravity center -resize "105x70^" -crop "105x70+0+0" +repage'
                      },
                      _90x90:   { geometry: '',
                                  convert_options: '-gravity center -resize "90x90^" -crop "90x90+0+0" +repage'
                      },
                      _80x57:   { geometry: '',
                                  convert_options: '-gravity center -resize "80x57^" -crop "80x57+0+0" +repage'
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
