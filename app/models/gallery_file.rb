# encoding: utf-8
# == Schema Information
#
# Table name: gallery_files # Связующая таблица фотогалереи с медиабиблиотекой
#
#  id              :integer          not null, primary key
#  gallery_id      :integer          not null                 # Внешний ключ для связи с фотогалерей
#  description     :string(255)                               # Описание изображения
#  placement_index :integer          default(0), not null     # Поле для задания порядка следования изображений относительно друг друга
#  is_published    :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class GalleryFile < ActiveRecord::Base
  include Paperclip
  attr_accessible :gallery_id,      # => "Внешний ключ для связи с таблицей фоторепортажа"
                  :description,     # => "Описание изображения"
                  :placement_index, # => "Поле для задания порядка следования изображений друг относительно друга"
                  :is_published    # => "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"

  has_one :gallery_image, foreign_key: :media_file_id, class_name: 'Gallery::GalleryImage', dependent: :destroy
  belongs_to :gallery, counter_cache: :gallery_photos_count

  # validations
  # ================================================================
  validates :gallery_id, presence: true

  # Methods
  # ================================================================

  def put_image(file)
    file = gallery_images.create(file: file)
    [file.file.url(:_90x90), file.id, id]
  end

  private

  # Добавляет водяной знак на изображение
  def add_watermarks
    image.styles.each do |s|             
      make_watermark(image, s)
    end
  end

end
