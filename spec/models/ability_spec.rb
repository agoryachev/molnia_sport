# encoding: utf-8
# == Schema Information
#
# Table name: abilities
#
#  id           :integer          not null, primary key
#  context      :string(255)
#  ability_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Ability do
  let(:ability) { FactoryGirl.create(:ability) }

  subject { ability }

  context 'отвечает и валидно' do 
    it { should respond_to(:context) }
    it { should respond_to(:ability_type) }

    it { should respond_to(:group_abilities) }
    it { should respond_to(:groups) }

    it { should have_many(:group_abilities) }
    it { should have_many(:groups) }
    
    it { should be_valid }
  end
end