# encoding: utf-8
# == Schema Information
#
# Table name: inside_statuses # Статус инсайд-новостей (трансферных слухов)
#
#  id    :integer          not null, primary key
#  title :string(255)      default(""), not null # Статус
#  color :string(255)      default("red_page")   # Цвет статуса
#

# Статусы трансферных слухов
class InsideStatus < ActiveRecord::Base

  attr_accessible \
    :title,
    :color

  has_many :insides

end