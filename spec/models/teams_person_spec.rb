# encoding: utf-8
# == Schema Information
#
# Table name: teams_persons # Связующая таблица команд (teams) с персоналиями (persons)
#
#  id        :integer          not null, primary key
#  team_id   :integer          not null              # Внешний ключ для связи с командой
#  person_id :integer          not null              # Внешний ключ для связи с персоной
#

require 'spec_helper'

describe TeamsPerson do
  let(:teams_person) { FactoryGirl.create(:teams_person) }

  subject { teams_person }

  context 'отвечает и валидно' do 

    it { should respond_to(:team) }
    it { should respond_to(:person) }

    it { should belong_to(:team) }
    it { should belong_to(:person) }
    
    it { should be_valid }
  end
end
