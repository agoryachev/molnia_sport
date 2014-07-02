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

require 'paperclip_processors/watermark'

# Медиа-файлы (фото-, видео-файлы)
class MediaFile < ActiveRecord::Base
  include Paperclip
  self.inheritance_column = :class_name
  attr_accessible :title,
                  :description,
                  :properties,
                  :file,
                  :file_file_size,
                  :file_content_type,
                  :file_file_name,
                  :file_file_path

  delegate :url, to: :file
  #delegate :path, to: :file

  serialize :properties

  # Вставленные меди-файлы
  # статистика для сортировки по ссылкам на файл
  has_many :counter_media_publications

  # Авторы
  has_many :authors_publications, as: :authorable, dependent: :destroy
  has_many :authors, through: :authors_publications

  acts_as_taggable_on :keywords

#  before_create :check_class_name

  # Изменяет имя файла на уникальный хэш
  # 
  # * *Returns* :
  #   - boolean
  #
  def randomize_file_name
    return if file_file_name.nil?
    if file_file_name_changed?
      extension = File.extname(file_file_name).downcase
      self.file.instance_write(:file_name, "#{SecureRandom.hex}#{extension}")
    end
  end

  private
  # Коллбэк проверяющий состояние поля class_name
  def check_class_name
    class_name = 'MediaFile::Image' if class_name.nil?
  end

end