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

# Frontend-пользователи
class User < ActiveRecord::Base
  include Oauth
  acts_as_voter
  attr_accessor :login
  devise  :registerable,
          :confirmable,
          :recoverable,
          :trackable,
          :validatable,
          :lockable,
          :rememberable,
          :omniauthable,
          :database_authenticatable

  attr_accessible :email,                 # Электронная почта пользователя (обязательно)
                  :encrypted_password,    # Хэш пароля пользователя
                  :password,              # Пароль пользователя
                  :password_confirmation, # Пароль пользователя
                  :remember_me,           # Запомнить пользователя
                  :name_first,            # Имя пользователя (обязательно)
                  :name_last,             # Фамилия пользователя (обязательно)
                  :nickname,              # никнейм пользователя
                  :name_v,                # Отчество пользователя (не обязательно)
                  :is_active,             # 1 - пользователь допущен в систему, 0 - пользователь не имеет возможность входа
                  :login,
                  :main_image_attributes,
                  :provider,
                  :uid

  has_many :comments, class_name: 'Comments::Comment', dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :votes, as: :voter, dependent: :destroy
  has_one :main_image, foreign_key: :media_file_id, class_name: "User::MainImage", dependent: :destroy

  # Validation
# ================================================================
  validates :name_first, :name_last, presence: true


  # Scopes
# ================================================================ 
  scope :find_by_email,    ->(email){where('lower(email) = ?', email.downcase )}
  scope :find_by_nickname, ->(nickname){where('lower(nickname) = ?', nickname.downcase )}
  scope :search, ->(params){ where('name_first LIKE :param OR name_last LIKE :param OR name_v LIKE :param', param: "%#{params}%") }

  # Nested forms
# ================================================================ 
  accepts_nested_attributes_for :main_image, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? && attributes[:description].blank? }

  # Methods
# ================================================================

  # Определяет является ли пользователь заблокированным
  #
  # @return [Boolean]
  #
  def locked?
    !locked_at.nil? && locked_at > Time.now
  end


  def full_name
    unless name_first.blank? || name_last.blank?
      if name_first == name_last
        name_first
      else
        "#{name_first} #{name_last}"
      end
    else
      nickname
    end
  end

  # Позволяет  аутентифицироваться по виртуальному атрибуту :login
  #
  # @param warden_conditions [Hash] param_desc
  # @return User [Object] найденный пользователь
  #
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      if login.index('@')
        find_by_email(login).first
      else
        find_by_nickname(login).first
      end
    else
      where(conditions).first
    end
  end

  # Загрузка главного изображения на сервер
  def put_image(file)
    main_image = User::MainImage.new
    main_image.file = file 
    update_attribute(:main_image, main_image) 
    [main_image.file.url(:_90x90), main_image.id]
  end

  # TO-DO: Отредактировать
  # has_one :avatar, foreign_key: :attachable_id, dependent: :destroy
  # accepts_nested_attributes_for :avatar, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].blank? }  
end
