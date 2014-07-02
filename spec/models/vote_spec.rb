# encoding: utf-8
# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string(255)
#  voter_id     :integer
#  voter_type   :string(255)
#  vote_flag    :boolean
#  vote_scope   :string(255)
#  vote_weight  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Vote do
  let(:vote) { FactoryGirl.create(:vote) }

  subject { vote }

  context 'отвечает и валидно' do 
    it { should respond_to(:votable) }
    it { should respond_to(:voter) }

    it { should belong_to(:votable) }
    it { should belong_to(:voter) }
    
    it { should be_valid }
  end
end