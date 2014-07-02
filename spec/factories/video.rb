# encoding: utf-8
# == Schema Information
#
# Table name: videos # Видеозаписи
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок видео-новости
#  content             :text                                      # Описание видео-ролика
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей категорий
#  employee_id         :integer                                   # Внешний ключ для связи с сотрудниками
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :video do

    title               Faker::Lorem.words(3).join(" ")
    content             Faker::Lorem.words(15).join(" ")
    category            { FactoryGirl.create(:category) }
    employee_id         1
    is_published        1
    is_deleted          0
    is_comments_enabled 0
    comments_count      0
    published_at        Time.now

  end
end