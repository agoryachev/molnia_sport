# -*- coding: utf-8 -*-
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

FactoryGirl.define do
  factory :group do

    title                 Faker::Lorem.words(3).join(" ")
    permissions           Faker::Lorem.words(15).join(" ")
    description           Faker::Lorem.words(3).join(" ")
    employees_count       1

  end
end