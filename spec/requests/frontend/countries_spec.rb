# encoding: utf-8
require 'spec_helper'

describe 'Страны' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_country)       { FactoryGirl.create(:country) }
    let(:new_category)      { FactoryGirl.create(:category) }
    let(:new_league)        { FactoryGirl.create(:league, category_id: new_category.id) }

    let(:leagues_group_1)   { FactoryGirl.create(:leagues_group, league_id: new_league.id) }
    let(:leagues_group_2)   { FactoryGirl.create(:leagues_group, league_id: new_league.id) }

    it do
      new_category.countries.push(new_country)
      leagues_group_1
      leagues_group_2
      visit "/categories/#{new_category.id}/countries/#{new_country.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.countries-for-specs')
    end
  end
end