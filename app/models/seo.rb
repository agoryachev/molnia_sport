# encoding: utf-8
# == Schema Information
#
# Table name: seos # SEO-информация
#
#  id           :integer          not null, primary key
#  seoable_id   :integer          not null              # Внешний ключ для материала, снабжаемого SEO-параметрами
#  seoable_type :string(255)      not null              # Внешний ключ для материала, снабжаемого SEO-параметрами
#  slug         :string(255)      default(""), not null # ЧПУ - человекопонятный урл
#  keywords     :string(255)      default(""), not null # Ключевые слова для META-тэга keywords
#  description  :string(255)      default(""), not null # Описание для META-тэга description
#

# SEO-атрибуты
class Seo < ActiveRecord::Base

  attr_accessible :slug,                  # ЧПУ - человекопонятный урл
                  :keywords,              # Содержимое META-тэга keywords
                  :description            # Содержимое META-тэга description

  belongs_to :seoable, polymorphic: true

  validates :slug, format: { with: /^[-a-zA-Z0-9_\.]*$/ }
end
