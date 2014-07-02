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

describe PhotoVideo do
  let(:photo_video) { FactoryGirl.create(:feed) }

  subject { photo_video }

  context 'отвечает и валидно' do 
    it { should respond_to(:feedable_id) }
    it { should respond_to(:feedable_type) }
    it { should respond_to(:feedable) }

    it { should belong_to(:feedable) }
    
    it { should be_valid }
  end
end