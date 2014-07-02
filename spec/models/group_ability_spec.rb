# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: group_abilities # Связующая таблица групп и экшенов для прав доступа
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null              # Внешний ключ для связи с группой
#  ability_id :integer          not null              # Внешний ключ для связи с экшеном (abilities)
#
require 'spec_helper'

describe GroupAbility do
  let(:group_ability) { FactoryGirl.create(:group_ability) }

  subject { group_ability }

  context 'отвечает и валидно' do 
    it { should respond_to(:group) }
    it { should respond_to(:ability) }

    it { should belong_to(:group) }
    it { should belong_to(:ability) }

    it { should be_valid }
  end
end