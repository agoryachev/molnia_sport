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

require 'spec_helper'

describe MediaFile do
  let(:media_file) { FactoryGirl.build(:media_file) }

  subject { media_file }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:description) }
    it { should respond_to(:properties) }
    it { should respond_to(:class_name) }
    #it { should respond_to(:file) }
    it { should respond_to(:file_file_size) }
    it { should respond_to(:file_content_type) }

    it { should respond_to(:counter_media_publications) }
    it { should respond_to(:authors_publications) }
    it { should respond_to(:authors) }

    it { should have_many(:counter_media_publications) }
    it { should have_many(:authors_publications) }
    it { should have_many(:authors) }

    it { should be_valid }
  end
end