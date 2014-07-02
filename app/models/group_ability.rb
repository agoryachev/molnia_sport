# encoding: utf-8
# == Schema Information
#
# Table name: group_abilities # Связующая таблица групп и экшенов для прав доступа
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null              # Внешний ключ для связи с группой
#  ability_id :integer          not null              # Внешний ключ для связи с экшеном (abilities)
#

class GroupAbility < ActiveRecord::Base
  attr_accessible :ability_id, :group_id

  belongs_to :ability
  belongs_to :group

end