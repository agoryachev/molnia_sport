# -*- coding: utf-8 -*- 
require 'streamio-ffmpeg'
require 'fileutils'
include Core::VideoConverter

class ConvertJob < Job.new(:local_path, :remote_path, :model) 
  def perform   
    begin      
      extensions = ['mp4','webm']      
      converter = JobVideoConverter.new(model, local_path, extensions)
      converter.connect(FILE_STORAGE["sftp"]["host"], FILE_STORAGE["sftp"]["user"], FILE_STORAGE["sftp"]["password"])
      converter.work
    ensure     
      converter.close_connection if converter
    end
  end

  def getDescription
    return remote_path
  end
end

