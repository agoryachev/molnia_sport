# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: groups # Группы администраторов, редакторов
#
#  id              :integer          not null, primary key
#  title           :string(255)      default(""), not null # Название группы
#  permissions     :string(21300)    default(""), not null # Права доступа для группы
#  description     :string(255)      default(""), not null # Описание группы(короткое)
#  employees_count :integer          default(0), not null  # Количество участников
#

require 'spec_helper'

describe Group do
  let(:group) { FactoryGirl.create(:group) }

  subject { group }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:permissions) }
    it { should respond_to(:description) }
    it { should respond_to(:employees_count) }
    it { should respond_to(:ability_ids) }

    it { should respond_to(:employees) }
    it { should respond_to(:group_abilities) }
    it { should respond_to(:abilities) }

    it { should have_many(:employees) }
    it { should have_many(:group_abilities) }
    it { should have_many(:abilities) }

    it { should be_valid }
  end
end