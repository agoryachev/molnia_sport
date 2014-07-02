# encoding: utf-8
# == Schema Information
#
# Table name: years
#
#  id          :integer          not null, primary key
#  title       :string(255)                            # Название сезона. Например: 2006/2007
#  league_year :integer                                # Год
#  league_id   :integer                                # Связь с лигами
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Year do
  let(:year) { FactoryGirl.create(:year) }

  subject { year }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:league_year) }
    it { should respond_to(:league_id) }

    it { should respond_to(:league) }
    it { should respond_to(:leagues_groups) }
    it { should respond_to(:leagues_statistics) }

    it { should belong_to(:league) }
    it { should have_many(:leagues_groups) }
    it { should have_many(:leagues_statistics) }
    
    it { should be_valid }
  end
end