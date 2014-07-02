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

# Страници, статья
class Page < ActiveRecord::Base
  include SeoMixin

  attr_accessible :title,
                  :content,
                  :is_published,
                  :is_deleted,
                  :is_comments_enabled

  # Relations
  # ================================================================ 
  has_many :comments, class_name: 'Comments::Comment', dependent: :destroy

  # Несколько авторов
  has_many :authors_publications, as: :authorable, dependent: :destroy
  has_many :authors, dependent: :destroy, through: :authors_publications

  # Scopes
  # ================================================================
  scope :is_published, ->(){ where('is_published = 1 AND is_deleted = 0') }
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :search, ->(params){ not_deleted.where('title LIKE :param OR content LIKE :param', param: "%#{params}%") }

  # Validations
  # ================================================================ 
  validates :title, presence: true
  validates :content, presence: true

end