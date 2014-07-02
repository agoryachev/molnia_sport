# encoding: utf-8
require 'spec_helper'

describe 'Галлереи' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/galleries'
    expect(status_code).to be 200
    expect(page).to have_content('Фотогалереи')
  end

  it 'new' do
    FactoryGirl.create(:category)
    visit '/backend/galleries/new'
    expect(status_code).to be 200
    expect(page).to have_content('Фотогалереи')
  end

  describe 'изменение' do
    let(:gallery) { FactoryGirl.create(:gallery) }

    it 'edit' do
      visit "/backend/galleries/#{gallery.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Фотогалереи')
    end

  end

end