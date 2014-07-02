# encoding: utf-8
require 'spec_helper'

describe 'Команды' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:team) { FactoryGirl.create(:team) }

    it do
      visit "/teams/#{team.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.teams-for-specs')
    end
  end
end