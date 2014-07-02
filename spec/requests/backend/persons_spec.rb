# encoding: utf-8
require 'spec_helper'

describe 'Персоналии' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/persons'
    expect(status_code).to be 200
    expect(page).to have_content('Игроки / Тренеры')
  end

  it 'new' do
    visit '/backend/persons/new'
    expect(status_code).to be 200
    expect(page).to have_content('Игроки / Тренеры')
  end

  describe 'изменение' do
    let(:person) { FactoryGirl.create(:person) }

    it 'edit' do
      visit "/backend/persons/#{person.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Игроки / Тренеры')
    end

  end

end