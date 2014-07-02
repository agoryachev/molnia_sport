# encoding: utf-8
require 'spec_helper'

describe 'Лиги' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/leagues'
    expect(status_code).to be 200
    expect(page).to have_content('Лиги')
  end

  it 'new' do
    FactoryGirl.create(:category)
    visit '/backend/leagues/new'
    expect(status_code).to be 200
    expect(page).to have_content('Лиги')
  end

  describe 'изменение' do
    let(:league) { FactoryGirl.create(:league) }

    it 'edit' do
      visit "/backend/leagues/#{league.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Лиги')
    end

  end

end