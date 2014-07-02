# encoding: utf-8
FactoryGirl.define do
  factory :author do 

    name            Faker::Lorem.words(3).join(" ")
    employee_id     1
    posts_count     0
    videos_count    0
    galleries_count 0
    media_count     0

  end
end