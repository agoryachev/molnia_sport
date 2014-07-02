# encoding: utf-8
# == Schema Information
#
# Table name: countries # Страна, входит в состав категории (category), содержит лиги/чемпионаты (league)
#
#  id         :integer          not null, primary key
#  title      :string(255)                            # Название страны
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Country do
  let(:country) { FactoryGirl.create(:country) }

  subject { country }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:category_ids) }

    it { should respond_to(:leagues) }
    it { should respond_to(:posts) }
    it { should respond_to(:teams) }
    it { should respond_to(:categories) }

    it { should have_many(:leagues) }
    it { should have_many(:posts) }
    it { should have_many(:teams) }
    it { should have_and_belong_to_many(:categories) }
   
    it { should be_valid }
  end
end
