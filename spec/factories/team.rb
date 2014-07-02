# encoding: utf-8
# == Schema Information
#
# Table name: teams # Команды (в рамках групповых видов спорта)
#
#  id                  :integer          not null, primary key
#  title               :string(255)      default(""), not null    # Название команды
#  subtitle            :string(255)                               # Подзаголовок
#  content             :text             default(""), not null    # Описание команды
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  country_id          :integer                                   # Связь со странами
#  category_id         :integer          not null                 # Внешний ключ для связи с категорией
#  created_at          :datetime
#  updated_at          :datetime
#

FactoryGirl.define do
  factory :team do

    title               Faker::Lorem.words(3).join(" ")
    subtitle            Faker::Lorem.words(5).join(" ")
    content             Faker::Lorem.words(15).join(" ")
    is_published        1
    is_deleted          0
    is_comments_enabled 0
    country             { FactoryGirl.create(:country) }
    category            { FactoryGirl.create(:category) }

  end
end