# encoding: utf-8
# == Schema Information
#
# Table name: feedbacks # Отзывы/пожелания пользователей
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null                 # Внешний ключ для связи с таблицей frontend-пользователей user
#  title      :string(255)      not null                 # Заголовок сообщения
#  content    :text             default(""), not null    # Содержимое сообщения
#  is_replied :boolean          default(FALSE), not null # 0 - на сообщение не был дан ответ, 1 - ответ был отправлен посетителю
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :feedback do

    user_id               1
    title                 Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    is_replied            1

  end
end