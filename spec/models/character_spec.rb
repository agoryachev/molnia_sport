# encoding: utf-8
# == Schema Information
#
# Table name: characters # Амплуа персоналии, гл.тренер, полузащитник и т.п.
#
#  id    :integer          not null, primary key
#  title :string(255)      not null              # Название
#

require 'spec_helper'

describe Character do
  let(:character) { FactoryGirl.create(:character) }

  subject { character }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:persons) }

    it { should have_many(:persons) }
    
    it { should be_valid }
  end
end
