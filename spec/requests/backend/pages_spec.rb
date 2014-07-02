# encoding: utf-8
require 'spec_helper'

describe 'Страницы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/pages'
    expect(status_code).to be 200
    expect(page).to have_content('Страницы')
  end

  it 'new' do
    visit '/backend/pages/new'
    expect(status_code).to be 200
    expect(page).to have_content('Страницы')
  end

  describe 'изменение' do
    let(:new_page) { FactoryGirl.create(:page) }

    it 'edit' do
      visit "/backend/pages/#{new_page.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Страницы')
    end

  end

end
