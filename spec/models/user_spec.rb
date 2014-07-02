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
#  uid                    :integer                                  # uid пользователя в соцсети
#  provider               :string(255)
#

require 'spec_helper'

describe User do
  let(:user) do
    user = FactoryGirl.attributes_for(:user)
    u = User.new(user)
    u.skip_confirmation!
    u.save
    u
  end

  subject { user }

  context 'отвечает и валидно' do 
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_me) }

    it { should respond_to(:name_first) }
    it { should respond_to(:name_last) }
    it { should respond_to(:name_v) }
    it { should respond_to(:nickname) }
    it { should respond_to(:is_active) }
    it { should respond_to(:login) }

    it { should respond_to(:comments) }
    it { should respond_to(:feedbacks) }

    it { should have_many(:comments) }
    it { should have_many(:feedbacks) }
   
    it { should be_valid }
  end
end
