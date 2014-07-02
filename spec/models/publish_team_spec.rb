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

require 'spec_helper'

describe PublishTeam do
  let(:publish_team) { FactoryGirl.create(:publish_team) }

  subject { publish_team }

  context 'отвечает и валидно' do 
    it { should respond_to(:team_id) }
    it { should respond_to(:publishable_id) }
    it { should respond_to(:publishable_type) }

    it { should respond_to(:team) }
    it { should respond_to(:publishable) }

    it { should belong_to(:team) }
    it { should belong_to(:publishable) }
    
    it { should be_valid }
  end
end