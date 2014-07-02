# encoding: utf-8
# == Schema Information
#
# Table name: publish_persons
#
#  id               :integer          not null, primary key
#  publishable_type :string(255)                            # Полиморфная связь с публикацией
#  publishable_id   :integer                                # Полиморфная связь с публикацией
#  person_id        :integer                                # Связь с игроком
#

require 'spec_helper'

describe PublishPerson do
  let(:publish_person) { FactoryGirl.create(:publish_person) }

  subject { publish_person }

  context 'отвечает и валидно' do 
    it { should respond_to(:person_id) }
    it { should respond_to(:publishable_id) }
    it { should respond_to(:publishable_type) }

    it { should respond_to(:person) }
    it { should respond_to(:publishable) }

    it { should belong_to(:person) }
    it { should belong_to(:publishable) }
    
    it { should be_valid }
  end
end