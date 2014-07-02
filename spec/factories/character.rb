# encoding: utf-8
# == Schema Information
#
# Table name: characters
#
#  id    :integer          not null, primary key
#  title :string(255)      not null              # Название
#
FactoryGirl.define do
  factory :character do

    title           Faker::Lorem.words(3).join(" ")

  end
end