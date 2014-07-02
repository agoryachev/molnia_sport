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

class MediaFile::Clip < MediaFile
  attr_accessible :file    
  has_many :videos, foreign_key: :media_id, dependent: :nullify  

  before_destroy :drop_files, :destroy_delayed_job

  has_attached_file :file,
                    storage: :sftp,
                    sftp_options: {
                      host: FILE_STORAGE['sftp']['host'],
                      user: FILE_STORAGE['sftp']['user'],
                      password: FILE_STORAGE['sftp']['password'],
                      paranoid: false
                    },                  
                    path: "#{FILE_STORAGE['sftp']['path']}/:custom_path/:basename.:extension",
                    url: "#{FILE_STORAGE['sftp']['url']}/:custom_path/:basename.:extension"
  
  
  validates_attachment_content_type :file, content_type: [ /^(video|application)\/(?:x-flv|x-m4v|mp4|avi|webm)$/, nil ], message: "Неподдерживаемый тип файла"
  before_post_process :randomize_file_name 

  after_create :convert_video


  private
    def drop_files
      begin       
        remote_path = self.file.path   
        file_name = File.basename(remote_path)
        ext_file = File.extname(file_name)[1..-1].downcase

        file_name = File.basename(remote_path,  File.extname(file_name))
        sftp = Net::SFTP.start(FILE_STORAGE["sftp"]["host"], FILE_STORAGE["sftp"]["user"], password: FILE_STORAGE["sftp"]["password"],  paranoid: false)
        
        ext = '.mp4'
        name_720 = file_name + '_720' + ext
        path_720 = File.join(File.dirname(remote_path), name_720)
        name_480 = file_name + '_480' + ext
        path_480 = File.join(File.dirname(remote_path), name_480)
        name_360 = file_name + '_360' + ext
        path_360 = File.join(File.dirname(remote_path), name_360)
        name_audio = file_name + '_audio' + ext
        path_audio = File.join(File.dirname(remote_path), name_audio)

        sftp.remove!(path_720) if file_exist?(sftp, path_720)
        sftp.remove!(path_480) if file_exist?(sftp, path_480)
        sftp.remove!(path_360) if file_exist?(sftp, path_360)
        sftp.remove!(path_audio) if file_exist?(sftp, path_audio)

        sftp.remove!(remote_path.gsub(/#{ext_file}$/, 'mp4')) if ext_file != 'mp4' && file_exist?(sftp, remote_path.gsub(/#{ext_file}$/, 'mp4'))
        sftp.remove!(remote_path.gsub(/#{ext_file}$/, 'webm')) if ext_file != 'webm' && file_exist?(sftp, remote_path.gsub(/#{ext_file}$/, 'webm')) 
      rescue => e     
        logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR: #{e.message}"
        logger.error e.backtrace[0]
      end
    end

    def file_exist?(sftp, pathname)
      begin
        sftp.stat!(pathname)
        true
      rescue Net::SFTP::StatusException => e
        false
      end
    end  

    def convert_video
      Delayed::Job.enqueue(::ConvertJob.new(file.path, file.path, self), :queue => 'converting')
    end

    def destroy_delayed_job
      Delayed::Job.where("handler LIKE '%\\nmodel: !ruby/ActiveRecord:Media::Clip\\n%\\n    id: ?\\n%'", self.id).destroy_all
    end
end
