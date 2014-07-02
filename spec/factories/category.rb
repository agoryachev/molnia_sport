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
FactoryGirl.define do
  factory :category do

    title           Faker::Lorem.words(3).join(" ")
    is_published    1
    placement_index 0
    color           "green_page"

  end
end