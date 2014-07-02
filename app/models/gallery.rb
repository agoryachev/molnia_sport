# encoding: utf-8
# == Schema Information
#
# Table name: galleries # Фотогалереи
#
#  id                   :integer          not null, primary key
#  title                :string(255)      not null                 # Заголовок фотогалереи
#  content              :string(255)                               # Описание фотогалереи
#  category_id          :integer          not null                 # Внешний ключ для связи с таблицей рубрик
#  employee_id          :integer                                   # Внешний ключ для связи с сотрудниками
#  is_published         :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted           :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled  :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  is_exclusive         :boolean          default(FALSE), not null # Эксклюзивный материал, изображения защищаются водяным знаком
#  delta                :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinks)
#  gallery_photos_count :integer          default(0), not null     # Количество изображений в фотогаллереи
#  comments_count       :integer          default(0), not null     # Количество комментариев к фотогаллереи
#  published_at         :datetime         not null                 # Дата и время публикации
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

# Галлерея
class Gallery < Content

  include SeoMixin

  attr_accessible :gallery_photos_count,     # Количество изображений в фотогаллереи
                  :gallery_files_attributes,  # Атрибуты входящих в галерею файлов
                  :is_exclusive,
                  :person_ids,
                  :team_ids

  # Relations
  # ================================================================
  has_one :photo_video, as: :feedable, dependent: :destroy
  has_one :main_image, foreign_key: :media_file_id, class_name: 'Gallery::MainImage', dependent: :destroy

  has_many :gallery_files, dependent: :destroy

  has_many :publish_persons, as: :publishable, dependent: :destroy
  has_many :persons, through: :publish_persons

  has_many :publish_teams, as: :publishable, dependent: :destroy
  has_many :teams, through: :publish_teams

    # Scopes
  # ================================================================
    scope :not_deleted,  ->(){ where('is_deleted = 0') } 
    scope :search, ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param', param: "%#{params}%") }

  # Nested Forms
  # ================================================================
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }
  accepts_nested_attributes_for :gallery_files, allow_destroy: true, reject_if: :all_blank

  # Накладываем или снимаем "водяной знак" на изображение
  # при изменения статуста "Эксклюзивно"
  after_save do
    if is_exclusive && is_exclusive_changed?
      add_watermarks
    elsif !is_exclusive && is_exclusive_changed?
      del_watermarks
    end
  end

  # Methods
  # ================================================================

  def put_image(file, put_main_image = true)
    if put_main_image
      main_image = Gallery::MainImage.new
      main_image.file = file
      update_attribute(:main_image, main_image)
      [main_image.file.url(:_90x90), main_image.id]
    else
      gallery_image = Gallery::GalleryImage.new
      gallery_image.file = file
      gallery_file = gallery_files.new
      gallery_file.gallery_image = gallery_image
      gallery_file.save
      [gallery_image.file.url(:_90x90), gallery_image.id]
    end
  end

  private

  # Добавляет водяной знак на изображения
  def add_watermarks(type = 'main_image')
    if type == 'gallery_files'
      gallery_files.each do |file|
        file.gallery_image.file.styles.each do |s|
          make_watermark(file.gallery_image.file, s)
        end
      end
    else
      if main_image.try(:file)
        main_image.file.styles.each do |s|             
          make_watermark(main_image.file, s)
        end
      end
      add_watermarks('gallery_files')
    end      
  end   

  # Удаляет водяной знак с изображения
  def del_watermarks(type = 'main_image')
    if type == 'gallery_files'
      gallery_files.each do |file|
        file.gallery_image.file.styles.each do |s|
          remove_watermark(file.gallery_image.file, s)
        end
      end
    else
      if main_image.try(:file)
        main_image.file.styles.each do |s|             
          remove_watermark(main_image.file, s)
        end
      end
      remove_watermarks('gallery_files')
    end   
  end
end