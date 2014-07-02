# encoding: utf-8
# == Schema Information
#
# Table name: years
#
#  id          :integer          not null, primary key
#  title       :string(255)                            # Название сезона. Например: 2006/2007
#  league_year :integer                                # Год
#  league_id   :integer                                # Связь с лигами
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :year do

    title               "2013/2014 зима"
    league_year         "2013"
    league_id           1

  end
end