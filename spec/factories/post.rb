# encoding: utf-8
# == Schema Information
#
# Table name: posts # Новости
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок новости
#  subtitle            :string(255)                               # Подзаголовок новости
#  content             :text             default(""), not null    # Содержимое новости
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей разделов
#  employee_id         :integer                                   # Внешний ключ для связи с сотрудниками
#  country_id          :integer                                   # Внешний ключ для связи со странами
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  delta               :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinks)
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :post do

    title               Faker::Lorem.words(3).join(" ")
    subtitle            Faker::Lorem.words(5).join(" ")
    content             Faker::Lorem.words(15).join(" ")
    category            { FactoryGirl.create(:category) }
    employee_id         1
    country             { FactoryGirl.create(:country) }
    is_published        1
    is_deleted          0
    is_comments_enabled 0
    delta               1
    comments_count      0
    published_at        Time.now

  end
end