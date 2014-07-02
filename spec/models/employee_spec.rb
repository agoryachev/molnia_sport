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

require 'spec_helper'

describe Employee do
  let(:employee) do
    employee = FactoryGirl.attributes_for(:employee)
    Employee.create(employee)
  end

  subject { employee }

  context 'отвечает и валидно' do 
    it { should respond_to(:nickname) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:email) }
    it { should respond_to(:group_id) }
    it { should respond_to(:name_first) }
    it { should respond_to(:name_last) }
    it { should respond_to(:remember_me) }
    it { should respond_to(:is_active) }

    it { should respond_to(:abilities) }
    it { should respond_to(:action_abilities) }
    it { should respond_to(:attr_abilities) }
    it { should respond_to(:partial_abilities) }
    it { should respond_to(:authors) }
    it { should respond_to(:posts) }
    it { should respond_to(:videos) }

    it { should have_many(:abilities) }
    it { should have_many(:action_abilities) }
    it { should have_many(:attr_abilities) }
    it { should have_many(:partial_abilities) }
    it { should have_many(:authors) }
    it { should have_many(:posts) }
    it { should have_many(:videos) }

    it { should belong_to(:group) }
   
    it { should be_valid }
  end
end