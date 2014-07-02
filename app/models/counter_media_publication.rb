# encoding: utf-8
# == Schema Information
#
# Table name: counter_media_publications # Промежуточная таблица для связи файлов медиа библиотеки с публикациями (новости, блоги и т.д.)
#
#  id               :integer          not null, primary key
#  publication_type :string(255)      not null              # Тип публикации(Post, MediaFile)
#  publication_id   :integer          not null              # Внешний ключ для связи с опубликованным материалом (Post, BlogPost)
#  media_file_id    :integer          not null              # Внешний ключ для связи с медиабиблиотекой
#

class CounterMediaPublication < ActiveRecord::Base  
  attr_accessible :publication_type, # Тип публикации(Post, BlogPost)"
                  :publication_id,   # Внешний ключ для связи с опубликованным материалом (Post, BlogPost)
                  :media_file_id     # Внешний ключ для связи с медиабиблиотекой MediaFile

  belongs_to :media_file
  belongs_to :publication, polymorphic: true

  # validations
  #===============================================================
  validates :publication_type, :publication_id, :media_file_id, presence: true 
end
