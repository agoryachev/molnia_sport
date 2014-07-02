# encoding: utf-8
require 'spec_helper'

describe 'Категории' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/categories'
    expect(status_code).to be 200
    expect(page).to have_content('Категории')
  end

  it 'new' do
    visit '/backend/categories/new'
    expect(status_code).to be 200
    expect(page).to have_content('Категории')
  end

  describe 'изменение' do
    let(:category) { FactoryGirl.create(:category) }

    it 'edit' do
      visit "/backend/categories/#{category.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Категории')
    end

  end

end
