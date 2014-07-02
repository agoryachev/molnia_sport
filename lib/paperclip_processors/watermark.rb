# Source: https://gist.github.com/laurynas/708077
# Based on
# https://github.com/ng/paperclip-watermarking-app/blob/master/lib/paperclip_processors/watermark.rb
# Modified by Laurynas Butkus
 
module Paperclip
  class Watermark < Processor
    # Handles watermarking of images that are uploaded.    
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :watermark_path, :position, :convert_options
    
    def initialize file, options = {}, attachment = nil
    super
      geometry          = options[:geometry]
      @file             = file
      @whiny            = options[:whiny].nil? ? true : options[:whiny]

      @format           = options[:format]
      @watermark_path   = options[:watermark_path]
      @position         = options[:watermark_position].nil? ? "SouthEast" : options[:watermark_position]      

      @crop             = geometry[-1,1] == '#'
      @target_geometry  = Geometry.parse geometry
      @current_geometry = Geometry.from_file @file
      @convert_options  = options[:convert_options]

      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end

    # Returns true if the +target_geometry+ is meant to crop.
    def crop?
      @crop
    end

    def target_geometry?
      not @target_geometry.blank?
    end

    # Returns true if the image is meant to make use of additional convert options.
    def convert_options?
      not @convert_options.blank?
    end
 
    # Performs the conversion of the +file+ into a watermark. Returns the Tempfile
    # that contains the new image.
    def make      
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode 

      if target_geometry?
        command = "convert"
        params = [File.expand_path(@file.path)]
        params += transformation_command
        params << File.expand_path(dst.path)
        begin
          success = Paperclip.run(command, params.flatten.compact.collect{|e| "'#{e}'"}.join(" "))
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error resizing and cropping #{@basename}" if @whiny
        end
      end 

      if convert_options?
        command = "convert"
        from_file = target_geometry? ? tofile(dst) : fromfile
        params = "#{from_file} #{@convert_options} #{tofile(dst)}"
        begin
          success = Paperclip.run(command, params)
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
        end
      end     

      if @watermark_path
        if convert_options? || target_geometry?
          scale = Geometry.from_file(File.expand_path(dst.path)).to_s.split('x')[0].to_i/6
        else
          scale = Geometry.from_file(File.expand_path(@file.path)).to_s.split('x')[0].to_i/6
        end
        watermark = File.new(@watermark_path)
        tmp_watermark = Tempfile.new(File.basename(watermark))
        command = "convert"
        params = "#{@watermark_path} -resize #{scale} #{File.expand_path(tmp_watermark)}"
        begin
          success = Paperclip.run(command, params)
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error resizing #{watermark}" if @whiny
        end
       
        command = "composite"
        if convert_options? || target_geometry?
          params = "-gravity #{@position} #{File.expand_path(tmp_watermark)} #{tofile(dst)} #{tofile(dst)}"
        else
          params = "-gravity #{@position} #{File.expand_path(tmp_watermark)} #{fromfile} #{tofile(dst)}"
        end
        
   
        begin
          success = Paperclip.run(command, params)
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
        end    
      end
          
      dst
    end
 
    def fromfile
      "\"#{ File.expand_path(@file.path) }[0]\""
    end
 
    def tofile(destination)
      "\"#{ File.expand_path(destination.path) }[0]\""
    end    

    def transformation_command
      scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
      trans = %W[-resize #{scale}]
      trans += %W[-crop #{crop} +repage] if crop
      trans
    end   
  end

  def make_watermark(file, style = nil, watermark_file = "app/assets/images/exclusive.jpg")
    if style
      remote_file_path = file.path(style.first)        
    else
      remote_file_path = file.path
    end

    geometry = style.last.geometry

    local_file_path = '/tmp/' + file.original_filename
    Net::SFTP.start(FILE_STORAGE["sftp"]["host"], FILE_STORAGE["sftp"]["user"], password: FILE_STORAGE["sftp"]["password"]) do |sftp|
      # Проверяем существование файла на удаленом сервере
      is_remote_file_exists = false
      begin
        sftp.stat!(remote_file_path) do |response|
          is_remote_file_exists = true if response.ok?
        end
      rescue
        is_remote_file_exists = false
      end

      if is_remote_file_exists
        sftp.download! remote_file_path, local_file_path

        if local_file_path.present?
          process = Watermark.new(File.new(local_file_path), { geometry: geometry, watermark_path: Rails.root.join(watermark_file) })
          result = process.make
          # Загружаем результаты преобразования обратно на сервер
          sftp.upload! result, remote_file_path
          # Удаляем временные файлы
          File.delete(local_file_path)
          File.delete(result)
        end
      end
    end
  end

  def remove_watermark(file, style = nil)
    return file unless style

    remote_file_path = file.path(style.first) 
    original_file    = file.path   

    geometry = style.last.geometry
    convert_options = style.last.convert_options    

    local_file_path = '/tmp/' + file.original_filename
    Net::SFTP.start(FILE_STORAGE["sftp"]["host"], FILE_STORAGE["sftp"]["user"], password: FILE_STORAGE["sftp"]["password"]) do |sftp|
      # Проверяем существование файла на удаленом сервере
      is_original_file_exists = false
      begin
        sftp.stat!(original_file) do |response|
          is_original_file_exists = true if response.ok?
        end
      rescue
        is_original_file_exists = false
      end

      if is_original_file_exists
        sftp.download! original_file, local_file_path

        if local_file_path.present?
          process = Watermark.new(File.new(local_file_path), { geometry: geometry, convert_options: convert_options })
          result = process.make
          # Загружаем результаты преобразования обратно на сервер
          sftp.upload! result, remote_file_path
          # Удаляем временные файлы
          File.delete(local_file_path)
          File.delete(result)
        end
      end
    end
  end
end