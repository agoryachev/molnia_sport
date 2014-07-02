# encoding: utf-8
# == Schema Information
#
# Table name: characters # Амплуа персоналии, гл.тренер, полузащитник и т.п.
#
#  id    :integer          not null, primary key
#  title :string(255)      not null              # Название
#

class Character < ActiveRecord::Base
  attr_accessible :title

  # Relations
# ================================================================
  has_many :persons

  # Validates
# ================================================================
  validates :title, presence: true, length: {within: 5..100}

  # Scopes
# ================================================================
  scope :search, ->(params){ where('title LIKE :param', param: "%#{params}%") }
end
