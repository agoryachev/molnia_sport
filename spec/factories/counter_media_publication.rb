# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: counter_media_publications # Промежуточная таблица для связи файлов медиа библиотеки с публикациями (новости, блоги и т.д.)
#
#  id               :integer          not null, primary key
#  publication_type :string(255)      not null              # Тип публикации(Post, MediaFile)
#  publication_id   :integer          not null              # Внешний ключ для связи с опубликованным материалом (Post, BlogPost)
#  media_file_id    :integer          not null              # Внешний ключ для связи с медиабиблиотекой
#
FactoryGirl.define do
  factory :counter_media_publication do

    publication_type    'Post'
    publication_id      1
    media_file_id       1

  end
end