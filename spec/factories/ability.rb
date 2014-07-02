# encoding: utf-8
FactoryGirl.define do
  factory :ability do 

    context         Faker::Lorem.words(3).join(" ")
    ability_type    "controllers"

  end
end