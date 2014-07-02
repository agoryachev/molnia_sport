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

FactoryGirl.define do
  factory :seo do

    slug          Faker::Lorem.words(1).join(" ")
    keywords      Faker::Lorem.words(7).join(",")
    description   Faker::Lorem.words(20).join(" ")
    seoable_id    1
    seoable_type  'Post'

  end
end
