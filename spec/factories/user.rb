# encoding: utf-8
# == Schema Information
#
# Table name: users # Frontend-пользователи
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null   # Электронная почта пользователя (обязательно)
#  encrypted_password     :string(255)      default(""), not null   # Хэш пароля пользователя
#  reset_password_token   :string(255)                              # Токен восстановления пароля
#  reset_password_sent_at :datetime                                 # Время, когда токен восстановления был выслан
#  remember_created_at    :datetime                                 # Запомнить меня
#  sign_in_count          :integer          default(0)              # Количество удачных попыток входа
#  current_sign_in_at     :datetime                                 # Текущее вход в
#  last_sign_in_at        :datetime                                 # Последний вход в
#  current_sign_in_ip     :string(255)                              # ip-адрес текущей сессии
#  last_sign_in_ip        :string(255)                              # ip-адрес последней сессии
#  confirmation_token     :string(255)                              # Токен активации пользователя
#  confirmed_at           :datetime                                 # Время подтверждения активации
#  confirmation_sent_at   :datetime                                 # Время, когда токен активации был выслан
#  name_first             :string(255)      not null                # Имя пользователя (обязательно)
#  name_last              :string(255)      not null                # Фамилия пользователя (обязательно)
#  name_v                 :string(255)                              # Отчество пользователя (не обязательно)
#  is_active              :boolean          default(TRUE), not null # 1 - пользователь допущен в систему, 0 - пользователь не имеет возможность входа
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  nickname               :string(255)                              # Никнейм пользователя
#  locked_at              :datetime                                 # время блокировки пользователя
#  unlock_token           :string(255)                              # токен разблокировки
#

FactoryGirl.define do
  factory :user do

    email                 'test@test.ru'
    password              '321321'
    password_confirmation '321321'
    is_active             1
    nickname              Faker::Lorem.words(1).join(" ")
    name_first            Faker::Lorem.words(1).join(" ")
    name_last             Faker::Lorem.words(1).join(" ")

  end
end