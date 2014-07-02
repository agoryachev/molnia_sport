# encoding: utf-8
# == Schema Information
#
# Table name: publish_persons
#
#  id               :integer          not null, primary key
#  publishable_type :string(255)                            # Полиморфная связь с публикацией
#  publishable_id   :integer                                # Полиморфная связь с публикацией
#  person_id        :integer                                # Связь с игроком
#

FactoryGirl.define do
  factory :publish_person do

    publishable          FactoryGirl.build(:post)
    person               FactoryGirl.build(:person)

  end
end
