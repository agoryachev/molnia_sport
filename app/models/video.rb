# encoding: utf-8
# == Schema Information
#
# Table name: videos # Видеозаписи
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок видео-новости
#  content             :text                                      # Описание видео-ролика
#  duration            :string(255)                               # Продолжительность видео в секундах
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей категорий
#  employee_id         :integer                                   # Внешний ключ для связи с сотрудниками
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Видео-ролик
class Video < Content

  include SeoMixin

  attr_accessible :clip_attributes,       # => "nested аттрибут для клипа"
                  :person_ids,
                  :team_ids

  # Relations
  # ================================================================

  # Заглавное изображение
  has_one :photo_video, as: :feedable, dependent: :destroy
  has_one :main_image, foreign_key: :media_file_id, class_name: "Video::MainImage", dependent: :destroy
  has_one :clip, foreign_key: :media_file_id, class_name: "Video::Clip", dependent: :destroy

  has_many :publish_persons, as: :publishable, dependent: :destroy
  has_many :persons, through: :publish_persons

  has_many :publish_teams, as: :publishable, dependent: :destroy
  has_many :teams, through: :publish_teams

  # Nested Forms
  # ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }
  accepts_nested_attributes_for :clip, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? }

    # Scopes
  # ================================================================
    scope :not_deleted,  ->(){ where('is_deleted = 0') }
    scope :search, ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param', param: "%#{params}%") }

  # Methods
  # ================================================================

  # Сохранение главного изображения видео-ролика
  #
  # @param file [File] объект, представляющий загруженный файл (изображение)
  # @param put_main_image [Boolean] неиспользуемый параметр, оставленный для обратной совместимости
  # @return [Array] массив с параметрами изображения
  #
  def put_image(file, put_main_image = true)
    main_image = Video::MainImage.new
    main_image.file = file 
    update_attribute(:main_image, main_image) 
    [main_image.file.url(:_90x90), main_image.id]
  end

  # Сохранения видео-ролика
  #
  # @param file [File] объект, представляющий загруженный файл (видео)
  # @param snapshot_time [Integer] смещение относитльно начала ролика в секундах, 
  #                                для которого берется кадр снимка
  # @param only_set_file [Boolean] если принимает значение true - изменяется только видео,
  #                                если false - и видео, и главное изображение
  # @return [Array] массив с параметрами изображения или false
  #
  def put_video(file, snapshot_time = 4, only_set_file = false)
    new_video = Video::Clip.new
    new_video.file = file        
    update_attribute(:clip, new_video)
    unless only_set_file 
      # Прикрепляем скриншот как main_image если пользователь установил минуту
      # или если пользователь не загрузил главное изображение
      if snapshot_time && snapshot_time.to_i > 0 || main_image.nil?
        grab_screenshot_from_video(snapshot_time)
      end
      convert(file.path, clip.path, self)
      return [clip.url, clip.id, main_image.file.url(:_90x90), main_image.id]
    end
  end

  private
    # Получает скриншот видео
    # 
    # @param offset [Integer] смещение относительно начала ролика в секундах
    # @return [nil]
    #
    def grab_screenshot_from_video(offset=4)
      unless self.clip.nil?
        begin
          if offset < 0
            offset = 0
          elsif offset > duration
            offset = duration
          end
          file_name = self.clip.file_file_name
          image_name = "#{Rails.root}/tmp/videos/#{id}/#{file_name.gsub(File.extname(file_name), '.jpg')}"
          system "ffmpeg  -itsoffset -#{offset} -i #{self.clip.url} -vcodec mjpeg -vframes 1 -an -f rawvideo #{image_name}"
          f = File.open(image_name)
          main_image = Video::MainImage.new
          main_image.file = f
          self.update_attribute(:main_image, main_image)
          f.close
        rescue Exception => e
          logger.error("#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR: #{e.message}")
          #puts e.message
          nil
        end
      else
        nil
      end
    end

    def convert(local_path, remote_path, model)        
      Delayed::Job.enqueue(::ConvertJob.new(local_path, remote_path, model), queue: 'converting')
    end

    def destroy_delayed_job
      Delayed::Job.where("handler LIKE '%\\nmodel: !ruby/ActiveRecord:Video\\n%\\n    id: ?\\n%'", self.id).destroy_all
    end
end
