# encoding: utf-8
# == Schema Information
#
# Table name: authors # Авторы статей (могут быть связанны с сотрудниками по полю employee_id)
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null              # Имя автора(или псевдоним)
#  employee_id     :integer                                # Идентификатор сотрудника, аккаунта автора в системе администрирования
#  posts_count     :integer          default(0), not null  # Количество новостей, принадлежащих автору
#  videos_count    :integer          default(0), not null  # Количество видео-сюжетов, принадлежащих автору
#  galleries_count :integer          default(0), not null  # Количество фотогалерей, принадлежащих автору
#  media_count     :integer          default(0), not null  # Количество файлов в медиабиблиотеке, принадлежащих автору
#

# Авторы статей (могут быть связанны с сотрудниками по полю employee_id)
class Author < ActiveRecord::Base
  attr_accessible :name,              # Имя автора(или псевдоним)
                  :employee_id,       # Идентификатор сотрудника, аккаунта автора в системе администрирования
                  :posts_count,       # Количество новостей, принадлежащих автору
                  :videos_count,      # Количество видео-сюжетов, принадлежащих автору
                  :galleries_count,   # Количество фотогалерей, принадлежащих автору
                  :media_count        # Количество файлов в медиабиблиотеке, принадлежащих автору
  # Relations
  # ================================================================ 
  has_many :authors_publications, dependent: :destroy
  #has_many :authorable, through: :authors_publications

  # Новости
  has_many :posts, through: :authors_publications,
            source: :authorable,  source_type: 'Post'

  # Загруженные файлы
  has_many :media, through: :authors_publications,
            source: :authorable,  source_type: "MediaFile"

  belongs_to :employee

  # Validates
  # ================================================================
  validates :name, presence: true, length: {within: 5..255}

  # Scopes
  # ================================================================
  scope :search, ->(params){ where('name LIKE :param', param: "%#{params}%") }

end