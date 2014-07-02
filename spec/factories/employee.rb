# encoding: utf-8
# == Schema Information
#
# Table name: employees # Backend-сотрудники (администраторы, редакторы)
#
#  id                     :integer          not null, primary key
#  nickname               :string(255)      default(""), not null    # Никнейм пользователя
#  email                  :string(255)      default(""), not null    # Электронная почта пользователя (обязательно)
#  encrypted_password     :string(255)      default(""), not null    # Хэш пароля пользователя
#  group_id               :integer          not null                 # Связь сотрудника с группой
#  name_first             :string(255)                               # Имя сотрудника (не обязательно)
#  name_last              :string(255)                               # Фамилия сотрудника (не обязательно)
#  reset_password_token   :string(255)                               # Токен восстановления пароля
#  reset_password_sent_at :datetime                                  # Время, когда токен восстановления был выслан
#  sign_in_count          :integer          default(0)               # Количество удачных попыток входа
#  current_sign_in_at     :datetime                                  # Текущее вход в
#  last_sign_in_at        :datetime                                  # Последний вход в
#  current_sign_in_ip     :string(255)                               # ip-адрес текущей сессии
#  last_sign_in_ip        :string(255)                               # ip-адрес последней сессии
#  remember_created_at    :datetime                                  # Запомнить меня
#  is_active              :boolean          default(FALSE), not null # 1 - редактор допущен в систему, 0 - редактор не имеет возможность входа
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do
  factory :employee do

    nickname              'dev'
    email                 { Faker::Internet.email }
    password              '321321'
    password_confirmation '321321'
    group_id              1
    name_first            Faker::Lorem.words(1).join(" ")
    name_last             Faker::Lorem.words(1).join(" ")
    is_active             1

  end

end