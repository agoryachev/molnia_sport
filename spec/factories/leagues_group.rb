# encoding: utf-8
# == Schema Information
#
# Table name: leagues_groups # Группы в рамках лиги, группы
#
#  id         :integer          not null, primary key
#  title      :string(255)      default(""), not null # Название группы
#  date_at    :date                                   # Дата старта игр в рамках группы
#  league_id  :integer          not null              # Внешний ключ для связи с таблицей лиг
#  year_id    :integer                                # Внешний ключ для связи с годами
#  created_at :datetime
#  updated_at :datetime
#
FactoryGirl.define do
  factory :leagues_group do

    title                 Faker::Lorem.words(3).join(" ")
    date_at               Time.now
    league_id             1
    year_id               1

  end
end