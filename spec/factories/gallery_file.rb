# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: gallery_files # Связующая таблица фотогалереи с медиабиблиотекой
#
#  id              :integer          not null, primary key
#  gallery_id      :integer          not null                 # Внешний ключ для связи с фотогалерей
#  description     :string(255)                               # Описание изображения
#  placement_index :integer          default(0), not null     # Поле для задания порядка следования изображений относительно друг друга
#  is_published    :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :gallery_file do

    gallery_id            1
    description           Faker::Lorem.words(15).join(" ")
    placement_index       0
    is_published          1

  end
end