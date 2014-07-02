# encoding: utf-8
# == Schema Information
#
# Table name: persons # Персоналии (игрок, тренер, владелец клуба и т.п.)
#
#  id                  :integer          not null, primary key
#  name_first          :string(255)      default(""), not null    # Имя
#  name_last           :string(255)      default(""), not null    # Фамилия
#  name_v              :string(255)                               # Отчество
#  content             :text             default(""), not null    # Описание
#  instagram           :string(255)                               # Ссылка на instagram
#  twitter             :string(255)                               # Ссылка на twitter
#  character_id        :integer                                   # Связь с таблицей character
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryGirl.define do
  factory :person do

    name_first            Faker::Lorem.words(3).join(" ")
    name_last             Faker::Lorem.words(3).join(" ")
    name_v                Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    instagram             ""
    twitter               ""
    character_id          1
    is_published          1
    is_deleted            0
    is_comments_enabled   0

  end
end