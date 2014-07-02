# encoding: utf-8
require 'spec_helper'

describe 'Авторы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/authors'
    expect(status_code).to be 200
    expect(page).to have_content('Авторы')
  end

  it 'new' do
    visit '/backend/authors/new'
    expect(status_code).to be 200
    expect(page).to have_content('Авторы')
  end

  describe 'изменение' do
    let(:author) { FactoryGirl.create(:author) }

    it 'edit' do
      visit "/backend/authors/#{author.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Авторы')
    end

  end

end
