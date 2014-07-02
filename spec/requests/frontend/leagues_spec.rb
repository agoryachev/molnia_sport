# encoding: utf-8
require 'spec_helper'

describe 'Лиги' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'index' do
    let(:new_category) { FactoryGirl.create(:category) }
    let(:league_1)     { FactoryGirl.create(:league, category_id: new_category.id) }
    let(:league_2)     { FactoryGirl.create(:league, category_id: new_category.id) }

    xit do
      visit "/categories/#{new_category.id}/leagues"
      expect(status_code).to be 200
      expect(page).to have_selector('.leagues-for-specs')
    end
  end

  describe 'show' do
    let(:new_category) { FactoryGirl.create(:category) }
    let(:league_1)     { FactoryGirl.create(:league, category_id: new_category.id) }

    xit do
      visit "/categories/#{new_category.id}/leagues/#{league_1.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.leagues-for-specs')
    end
  end
end