# encoding: utf-8
# == Schema Information
#
# Table name: pages # Страницы сайта
#
#  id                  :integer          not null, primary key
#  title               :string(255)      default(""), not null    # Заголовок страницы
#  content             :text             default(""), not null    # Содержимое страницы
#  is_published        :boolean          default(TRUE)            # 1 - страница доступна для просмотра, 0 - страница не доступна для просмотра
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryGirl.define do
  factory :page do

    title                 Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    is_published          1
    is_deleted            0
    is_comments_enabled   0

  end
end