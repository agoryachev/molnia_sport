# encoding: utf-8
require 'spec_helper'

describe 'Страны' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/countries'
    expect(status_code).to be 200
    expect(page).to have_content('Страны')
  end

  it 'new' do
    visit '/backend/countries/new'
    expect(status_code).to be 200
    expect(page).to have_content('Страны')
  end

  describe 'изменение' do
    let(:country) { FactoryGirl.create(:country) }

    it 'edit' do
      visit "/backend/countries/#{country.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Страны')
    end

  end

end
