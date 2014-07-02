# encoding: utf-8
# == Schema Information
#
# Table name: authors_publications # Связующая таблица авторов с публикациями (Галерея, Видео, Новость)
#
#  id              :integer          not null, primary key
#  author_id       :integer          not null              # Внешний ключ для связи с автором
#  authorable_type :string(255)      not null              # Тип связанной публикации (Post, Video, Gallery)
#  authorable_id   :integer          not null              # Внешний ключ для связи с публикацией (Post, Video, Gallery)
#

# Модель, связывающая авторов с публикациями
class AuthorsPublication < ActiveRecord::Base

  belongs_to :author
  belongs_to :authorable, polymorphic: true

  # Комбинация :authorable_type, :authorable_id, :author_id должна быть уникальна
  validates_uniqueness_of :authorable_type, scope: [:authorable_id, :author_id]

end