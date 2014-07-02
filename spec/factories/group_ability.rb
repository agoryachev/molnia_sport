# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: group_abilities # Связующая таблица групп и экшенов для прав доступа
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null              # Внешний ключ для связи с группой
#  ability_id :integer          not null              # Внешний ключ для связи с экшеном (abilities)
#
FactoryGirl.define do
  factory :group_ability do

    group                 FactoryGirl.build(:group)
    ability               FactoryGirl.build(:ability)

  end
end