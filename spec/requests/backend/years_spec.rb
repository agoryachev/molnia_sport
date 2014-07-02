# encoding: utf-8
require 'spec_helper'

describe 'Годы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'new' do
    FactoryGirl.create(:country)
    visit '/backend/years/new'
    expect(status_code).to be 200
    expect(page).to have_content('Год')
  end

  describe 'изменение' do
    let(:year) do
      year = FactoryGirl.create(:year)
      league = FactoryGirl.create(:league)
      league.country = FactoryGirl.create(:country)
      league.save!
      year.league = league
      year.save!
      year
    end

    it 'edit' do
      visit "/backend/years/#{year.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Год')
    end

  end

end
