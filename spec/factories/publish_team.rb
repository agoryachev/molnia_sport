# encoding: utf-8
# == Schema Information
#
# Table name: publish_teams
#
#  id               :integer          not null, primary key
#  publishable_type :string(255)                            # Полиморфная связь с публикацией
#  publishable_id   :integer                                # Полиморфная связь с публикацией
#  team_id          :integer                                # Связь с командой
#

FactoryGirl.define do
  factory :publish_team do

    publishable          FactoryGirl.build(:post)
    team_id              1

  end
end
