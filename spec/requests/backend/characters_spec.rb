# encoding: utf-8
require 'spec_helper'

describe 'Амплуа' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/characters'
    expect(status_code).to be 200
    expect(page).to have_content('Амплуа')
  end

  it 'new' do
    visit '/backend/characters/new'
    expect(status_code).to be 200
    expect(page).to have_content('Амплуа')
  end

  describe 'изменение' do
    let(:character) { FactoryGirl.create(:character) }

    it 'edit' do
      visit "/backend/characters/#{character.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Амплуа')
    end

  end

end