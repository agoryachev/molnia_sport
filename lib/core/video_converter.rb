# -*- coding: utf-8 -*-
module Core::VideoConverter
  class JobVideoConverter
    # ORIGINAL_PREFIX = 'original_'
    TRANSCODE_PREFIX = 'transcode_'

    def initialize(model, local_path, extensions, main_extension = 'mp4')   
      #удаление главного расширения из списка, если оно там есть
      @extensions     = extensions #.delete_if{|e| e == main_extension}
      @main_extension = main_extension
      if model.class.name == 'Media::Clip'
        @remote_path    = model.file.path
        @transcode_dir = Rails.root.join('tmp', 'uploads').to_s
        Dir.mkdir(@transcode_dir) unless Dir.exists?(@transcode_dir)
      else    
        @remote_path    = model.clip.path
        @transcode_dir = File.dirname(local_path)
      end
      @model          = model    
      @logger         = Logger.new(Rails.root.join("log","video_converter.log"),3,100*1024*1024)
      @local_path     = local_path
      
      raise 'Задача не действительна.' unless valid_job?    
      
      # изменение локального пути у файла
      # file_name       = File.basename(local_path)   
      # new_local_path  = local_path.gsub(/#{file_name}$/, ORIGINAL_PREFIX + file_name)
      
      # File.rename(local_path, new_local_path)
      
      # @local_path = new_local_path   
    end

    def connect(host, user, password)
      begin
        @sftp = Net::SFTP.start(host, user, password: password,  paranoid: false)
      rescue => e 
        @logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR :: Converter#convert method :: #{e.message}"
        @logger.error e.backtrace.slice(0,3).join('\n')
        raise  
      end
    end

    def close_connection
      @sftp.close_channel if @sftp 
    end

    def work
      begin
        ext_file      = File.extname(@remote_path)[1..-1]

        for extension in @extensions
          qualities = CONVERT_OPTS["ffmpeg"][extension]
          qualities.each do |quality|        
            upload_path = @remote_path.gsub(/#{ext_file}$/, extension)
            if extension == 'mp4'
              postfix = '_' + quality[0]
              file_name = File.basename(@remote_path, File.extname(@remote_path)) + postfix + ".#{extension}"
              upload_path = File.join(File.dirname(@remote_path), file_name)
              quality = quality[1]
            end
            local_transcode_path = convert(extension,quality)          
            unless valid_job?
              File.delete(local_transcode_path)
              raise 'Задача не действительна.'
            end 
            @sftp.remove!(upload_path) if file_exist?(upload_path)
            @sftp.upload!(local_transcode_path, upload_path, progress: UploadHandler.new)
            File.delete(local_transcode_path) 
          end           
        end

        # if File.exists?(@local_path) 
        #   File.rename(@local_path, File.join(File.dirname(@local_path), File.basename(@local_path).gsub(/^#{ORIGINAL_PREFIX}/, '')))  
        # end
      rescue => e 
        @logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR :: Converter#convert method :: #{e.message}"
        @logger.error e.backtrace.slice(0,3).join('\n')
        # if File.exists?(@local_path) 
        #   File.rename(@local_path, File.join(File.dirname(@local_path), File.basename(@local_path).gsub(/^#{ORIGINAL_PREFIX}/, '')))  
        # end
        
        transcode_file = File.join(@transcode_dir, TRANSCODE_PREFIX + File.basename(@local_path))
        File.delete(transcode_file) if File.exist?(transcode_file)

        #удаление закаченных сконвертированных файлов 
        @extensions.each do |e|
          qualities = CONVERT_OPTS["ffmpeg"][e]
          qualities.each do |q| 
            path = @remote_path.gsub(/#{ext_file}$/, e)
            if e == 'mp4'
              postfix = '_' + q[0]
              file_name = File.basename(@remote_path, File.extname(@remote_path)) + postfix + ".#{e}"
              path = File.join(File.dirname(@remote_path), file_name)
            end
            @sftp.remove!(path) if file_exist?(path)
          end  
        end
        raise   
      end
    end

    private   
      
    def convert(extension,quality)
      start_time  = nil;
      end_time    = nil;
      ext_file    = File.extname(@local_path)
      local_transcode_path = File.join(@transcode_dir, TRANSCODE_PREFIX + File.basename(@local_path).gsub(/#{ext_file}$/, '.' + extension))
      
      if File.exists?(local_transcode_path)
        File.delete(local_transcode_path)
      end
      
      movie = FFMPEG::Movie.new(@local_path)
      
      movie.transcode(local_transcode_path, quality) do |progress| 
        if progress == 0
          start_time  = Time.now 
        end

        if progress == 1
          end_time    = Time.now
        end

        printf((progress < 1 ? "\rProgress:  %02d\%" : "\rProgress: %3d\%"), progress * 100)
        $stdout.flush
        print('  ') if progress == 1.0
      end

      puts 'Converting time: ' + (end_time - start_time).round.to_s + ' seconds.'
      return local_transcode_path
    end

    def valid_job?
      if @model.class.name == 'Media::Clip'
        @model.class.exists?(@model.id) && !@model.file.nil? && @model.file.path == @remote_path && File.exists?(@local_path)
      else
        @model.class.exists?(@model.id) && !@model.clip.nil? && @model.clip.path == @remote_path && File.exists?(@local_path)
      end
    end

    def file_exist?(pathname)
      begin
        @sftp.stat!(pathname)
        true
      rescue Net::SFTP::StatusException => e
        false
      end
    end

  end

  class UploadHandler
    def on_open(uploader, file)
      puts "starting upload: #{file.local} -> #{file.remote} (#{file.size} bytes)"
      @start_time = Time.now
    end

    def on_put(uploader, file, offset, data)
     #puts "writing #{data.length} bytes to #{file.remote} starting at #{offset}"
    end

    def on_close(uploader, file)
      puts "Finished with #{file.remote}"
      puts 'Uploading time: ' + (Time.now - @start_time).round.to_s
    end

    def on_mkdir(uploader, path)
      #puts "creating directory #{path}"
    end

    def on_finish(uploader)
      #puts "all done!"
    end
  end

end