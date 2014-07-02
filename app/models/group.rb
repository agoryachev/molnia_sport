# encoding: utf-8
# == Schema Information
#
# Table name: groups # Группы администраторов, редакторов
#
#  id              :integer          not null, primary key
#  title           :string(255)      default(""), not null # Название группы
#  permissions     :string(21300)    default(""), not null # Права доступа для группы
#  description     :string(255)      default(""), not null # Описание группы(короткое)
#  employees_count :integer          default(0), not null  # Количество участников
#

class Group < ActiveRecord::Base
  attr_accessible :title,           # => "Название группы"
                  :permissions,     # => "Права доступа для группы"
                  :description,     # => "Описание группы(короткое)"
                  :employees_count, # => "Количество участников"
                  :ability_ids      # => "ids связанных abilities"
  serialize :permissions  

  # relations
  #===============================================================         
  has_many :employees

  # Возможности доступа
  has_many :group_abilities, dependent: :destroy
  has_many :abilities, through: :group_abilities

  # validations
  #===============================================================
  validates :title, presence: true
end
