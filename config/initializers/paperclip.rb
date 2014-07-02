# encoding: utf-8
# Подстановки для путей к файлам на контент-сервере (PaperClip через SFTP)
# Пример использования см. в app/models/post/main_image.rb
Paperclip.interpolates :parent_id do |attachment, style|
  attachment.instance.media_file_id
end

Paperclip.interpolates :gallery_id do |attachment, style|
  attachment.instance.gallery_id
end

Paperclip.interpolates :video_id do |attachment, style|
  attachment.instance.id
end

Paperclip.interpolates :date_to_path do |attachment, style|
  attachment.instance.created_at.strftime("/%Y/%m")
end

Paperclip.interpolates :day_to_path do |attachment, style|
  attachment.instance.created_at.strftime("%d")
end

Paperclip.interpolates :galleries_date do |attachment, style|
  attachment.instance.created_at.strftime("/%Y/%m/%d")
end

Paperclip.interpolates :videos_path do |attachment, style|
  attachment.instance.created_at.strftime("/%Y/%m/%d")
end

# Медиа-библиотека: общие файлы
Paperclip.interpolates :custom_path do |attachment, style|
  path = attachment.instance.file_file_path
  if style == :thumb
    # Уменьшенные копии - в скрытую папку
    path.blank? ? 'media/.thumb/uploads' : path.gsub(/^media/, "media/.thumb")
  else
    path.blank? ? 'media/uploads' : path
  end
end
