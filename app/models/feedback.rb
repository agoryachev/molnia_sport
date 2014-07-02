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

# Обратная связь с посетителями портала
class Feedback < ActiveRecord::Base
  attr_accessible :title,          # Заголовок сообщения
                  :content,        # Содержимое сообщения
                  :is_replied      # 0 - на сообщение не был дан ответ, 1 - ответ был отправлен посетителю

  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

end
