# encoding: utf-8
# == Schema Information
#
# Table name: post_statuses # Статус новостей (инфографика, live из Бразилии, стадионы, судьи)
#
#  id    :integer          not null, primary key
#  title :string(255)      default(""), not null # Статус
#  color :string(255)      default("red_page")   # Цвет статуса
#  image :string(255)                            # Путь к изображению, которое накладывается на главное изображение
#


# Статусы новостей
class PostStatus < ActiveRecord::Base

  attr_accessible \
    :title,
    :color,
    :image

  belongs_to :posts

end
