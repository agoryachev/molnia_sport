# encoding: utf-8
# == Schema Information
#
# Table name: feeds # Лента со всеми материалами: Новости, Галлереи и Видео
#
#  id            :integer          not null, primary key
#  feedable_id   :integer
#  feedable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Feed do
  let(:feed) { FactoryGirl.create(:feed) }

  subject { feed }

  context 'отвечает и валидно' do 
    it { should respond_to(:feedable) }
    it { should belong_to(:feedable) }
   
    it { should be_valid }
  end
end
