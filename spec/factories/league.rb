# encoding: utf-8
# == Schema Information
#
# Table name: leagues # Лиги, чемпионаты
#
#  id                  :integer          not null, primary key
#  category_id         :integer                                   # Внешний ключ для связи с категорией
#  country_id          :integer          default(0)               # Внешний ключ для связи с странами
#  title               :string(255)      default(""), not null    # Название лиги
#  content             :text                                      # Описание лиги
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryGirl.define do
  factory :league do

    category              { FactoryGirl.create(:category) }
    country_id            1
    title                 Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    is_published          1
    is_deleted            0
    is_comments_enabled   1

  end
end