# encoding: utf-8
# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  title           :string(255)      default(""), not null    # Заголовок категории
#  is_published    :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  placement_index :integer          default(0), not null     # Поле для задания порядка следования категорий на одном уровне относительно друг друга
#  color           :string(255)      default("red_page")      # Гавный цвет категории
#

# Новости
class Category < ActiveRecord::Base
  include SeoMixin
  # acts_as_nested_set
  attr_accessible :title,                 # Заголовок категории
                  :is_published,          # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
                  :placement_index,       # Позиция категории
                  :color                  # Цвет категории

  # Relations
  # ================================================================
  has_many :posts, dependent: :nullify
  has_many :galleries
  has_many :videos
  has_many :teams
  has_many :leagues
  has_and_belongs_to_many :countries


  # Validates
  # ================================================================
  validates :title, presence: true, length: {within: 5..255}

  # Scopes
  # ================================================================
  #  default_scope { order(:placement_index, created_at: :desc) }
  scope :search, ->(params){ where(arel_table[:title].matches ("%#{params}%")) }
  scope :is_published, ->(){ where(arel_table[:is_published].eq(1)) }

  # Methods
  # ================================================================
  
  # Цвета для использования в селекте при редактировании категории
  # 
  # @return [Array] массив цветов
  #
  def self.colors
    [ %w(Красный red_page), %w(Синий blue_page), %w(Зеленый green_page) ]
  end

  # Собирает категории для выподающего списка
  #
  # @return [Array] массив категорий с title и id
  #
  def self.categories_for_select
    to_ar = ->(_){[_.title, _.id]}
    select([:title, :id]).map(&to_ar)
  end
end
