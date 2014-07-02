# encoding: utf-8
# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  title      :string(255)                            # Название страны
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :country do

    title            Faker::Lorem.words(3).join(" ")

  end
end