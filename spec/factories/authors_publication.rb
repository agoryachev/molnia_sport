# encoding: utf-8
FactoryGirl.define do
  factory :authors_publication do 

    sequence(:author_id)   { |n| n }
    authorable_type  'Post'
    sequence(:authorable_id)   { |n| n }

  end
end