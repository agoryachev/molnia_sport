# encoding: utf-8
require 'spec_helper'

describe 'Группы / Туры' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/leagues_groups'
    expect(status_code).to be 200
    expect(page).to have_content('Группы / Туры')
  end

  it 'new' do
    #FactoryGirl.create(:category)
    visit '/backend/leagues_groups/new'
    expect(status_code).to be 200
    expect(page).to have_content('Группы / Туры')
  end

  describe 'изменение' do
    let(:leagues_group) do
      LeaguesGroup.destroy_all
      League.destroy_all
      Country.destroy_all
      Year.destroy_all
      leagues_group = FactoryGirl.create(:leagues_group)
      league = FactoryGirl.create(:league)
      league.country = FactoryGirl.create(:country)
      league.save!
      leagues_group.league = league
      leagues_group.year = FactoryGirl.create(:year)
      leagues_group.save!
      leagues_group
    end

    it 'edit' do
      visit "/backend/leagues_groups/#{leagues_group.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Группы / Туры')
    end

  end

end