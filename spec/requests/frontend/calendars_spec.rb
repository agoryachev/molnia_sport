# encoding: utf-8
require 'spec_helper'

describe 'Календари' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'index' do
    let(:league) { FactoryGirl.create(:league) }

    it do
      # league.save
      visit "/calendars?league_id=#{league.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.calendars-for-specs')
    end
  end
end