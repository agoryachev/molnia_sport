# encoding: utf-8
# == Schema Information
#
# Table name: columnist_posts # Заметки колумнистов
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок заметки
#  subtitle            :string(255)                               # Подзаголовок заметки
#  content             :text             default(""), not null    # Содержимое заметки
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей разделов
#  employee_id         :integer          not null                 # Внешний ключ для связи с таблицей сотрудников
#  columnist_id        :integer          not null                 # Внешний ключ для связи с таблицей колумнистов
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  delta               :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinx)
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :columnist_post do

    title                 Faker::Lorem.paragraph(1)
    subtitle              Faker::Lorem.paragraph(2)
    content               Faker::Lorem.paragraph(10)
    category              { create(:category) }
    employee              { create(:employee) }
    columnist             { create(:columnist) }
    is_published          true
    is_deleted            false
    is_comments_enabled   true
    delta                 true
    comments_count        0
    published_at          Time.now

  end
end
