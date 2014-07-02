# encoding: utf-8
require 'spec_helper'

describe 'Видео' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_video) { FactoryGirl.create(:video) }

    it do
      visit "/categories/#{new_video.category.id}/videos/#{new_video.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.videos-for-specs')
    end
  end
end