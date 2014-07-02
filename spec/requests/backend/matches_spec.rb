# encoding: utf-8
require 'spec_helper'

describe 'Матчи' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'new' do
    visit '/backend/matches/new'
    expect(status_code).to be 200
    expect(page).to have_content('Страницы')
  end

  describe 'изменение' do
    let(:match) do
      match = FactoryGirl.create(:match)
      leagues_group = FactoryGirl.create(:leagues_group)
      league = FactoryGirl.create(:league)
      league.country = FactoryGirl.create(:country)
      league.save!
      leagues_group.league = league
      leagues_group.year = FactoryGirl.create(:year)
      leagues_group.save!
      match.leagues_group = leagues_group
      match.save!
      match
    end

    it 'edit' do
      visit "/backend/matches/#{match.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Матчи')
    end

  end

end
