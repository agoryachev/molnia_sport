require 'fileutils'
require 'mime/types'
require 'streamio-ffmpeg'

module Core::AsynchUploader
  module InstanceMethods
    def asynch_upload(params, model_name)
      p params
      #обработка нажимания кнопки Стоп на клиенте
      if params[:status] == 'abort'
        delete(model_name, params[:id], params[:filename])       
        return true
      end

      begin
        model_dir = make_dir(model_name, params[:id])
        file = File.open(File.join(model_dir, params[:name]),'a+b')
        upload_data = params[:file].read   
        file.write(upload_data) 
        file.flush        
        if !params[:chunk] || (params[:chunk].to_i == params[:chunks].to_i - 1)
          cap_model_name = normalize_model_name(model_name)
          model = cap_model_name.constantize.find(params[:id])
          #video         
          if params[:name] =~ /(mp4|flv|webm|m4v|avi)$/ 
            duration = FFMPEG::Movie.new(file.path).duration
            model.update_attribute(:duration, duration) if model.respond_to?(:duration=)
            #file_url и id относятся к видео файлу
            file_url, id, image_url, image_id = model.put_video(file, params[:snapshot_time].to_i)
            type = 'video'                
          #audio
          elsif params[:name] =~ /mp3$/
            #file_url и id относятся к аудио файлу
            file_url, id = model.put_audio(file)
            type = 'audio'
            delete(model_name, params[:id], File.basename(file.path))
          #image
          else         
            #file_url и id относятся к изображению
            if params['_plupload_upload'] == 'single' 
              file_url, id = model.put_image(file) 
            else
              file_url, id = model.put_image(file, false)
            end            
            type = 'image'            
            delete(model_name, params[:id], File.basename(file.path))            
          end                
          response = {id: id, file_url: file_url, type: type, model_name: model_name.to_s, model_id: params[:id]}
          response.merge!({duration: duration, image_url: image_url, image_id: image_id}) if type == 'video' 
          return response        
        else         
          return true 
        end
      rescue Exception => e
        delete(model_name, params[:id], File.basename(file.path))
        raise
      ensure
        file.close
      end      
    end
  end

  private
  
  def delete(model_name, id, file_name)
    model_dir = Rails.root.join('tmp', model_name.to_s.downcase.pluralize, id.to_s).to_s
    File.delete(File.join(model_dir, file_name)) rescue nil
    FileUtils.rm_rf(model_dir) if Dir[File.join(model_dir, '*')].empty? 
  end


  def make_dir(type, id)
    main_dir = Rails.root.join('tmp', type.to_s.downcase.pluralize).to_s
    model_dir = File.join(main_dir, id.to_s)
    Dir.mkdir(main_dir) unless Dir.exists?(main_dir)    
    Dir.mkdir(model_dir) unless Dir.exists?(model_dir)
    return model_dir     
  end

  def self.included(receiver)   
    receiver.send :include, InstanceMethods
  end

  # Возвращает из символа :model_of_name название модели ModelOfName
  # 
  # * *Args*    :
  #   - +name+ Symbol название модели
  # * *Returns* :
  #   - String название модели в виде строки
  #
  def normalize_model_name(model_name)
    model_name.to_s.classify
  end
end