# encoding: utf-8
require 'spec_helper'

describe 'Персоналии' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_person) { FactoryGirl.create(:person) }
    let(:new_team)   { FactoryGirl.create(:team) }

    it do
      new_person.teams.push new_team
      new_person.save
      visit "/persons/#{new_person.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.persons-for-specs')
    end
  end
end