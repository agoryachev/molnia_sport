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

class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname,           # => "Никнейм сотрудника"
                  :password, 
                  :password_confirmation,
                  :email,              # => "Электронный адрес сотрудника"
                  :group_id,           # => "Связь сотрудника с группой"
                  :name_first,         # => "Имя сотрудника (не обязательно)"
                  :name_last,          # => "Фамилия сотрудника (не обязательно)"
                  :remember_me,        # => "Виртуальный атрибут для devise rememberable"
                  #:avatar_attributes,   # => "Атрибуты загружаемого изображения"
                  :is_active           # => "Активен ли пользователь"

# Relations
  #=============================================
  belongs_to :group, counter_cache: true
  has_many :abilities, through: :group
  has_many( :action_abilities, 
            { through: :group, 
              source: :abilities, 
              conditions: { ability_type: 'controllers' } })
  has_many( :attr_abilities, 
            { through: :group, 
              source: :abilities, 
              conditions: { ability_type: 'models' } })
  has_many( :partial_abilities, 
            { through: :group, 
              source: :abilities, 
              conditions: { ability_type: 'partials' } })

  has_many :authors
  has_many :posts
  has_many :videos

    # Scopes
  # ================================================================
    scope :search, ->(params){ where('email LIKE :param OR nickname LIKE :param OR name_first LIKE :param OR name_last LIKE :param', param: "%#{params}%") }

  # Проверка работника на право обновления поля is_published, is_deleted
  # 
  # @return [Boolean]
  #
  def can_update_flags?
    group.abilities.where(context: "controllers.publication_flags.update").first ? true : false
  end


  def full_name
    unless name_first.blank? || name_last.blank?
      "#{name_first} #{name_last}"
    else
      nickname
    end
  end
end
