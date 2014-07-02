# encoding: utf-8
# == Schema Information
#
# Table name: countries # Страна, входит в состав категории (category), содержит лиги/чемпионаты (league)
#
#  id         :integer          not null, primary key
#  title      :string(255)                            # Название страны
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Country < ActiveRecord::Base
  attr_accessible :title, :category_ids

  # Relations
# ================================================================ 
  has_and_belongs_to_many :categories
  has_many :leagues
  has_many :posts
  has_many :teams

  # Scopes
# ================================================================
  scope :search, ->(params){ where('title LIKE :param', param: "%#{params}%") }

  # Validates
# ================================================================ 
  validates :title, uniqueness: true, presence: true
end
