# encoding: utf-8
require 'spec_helper'

describe 'Пользователи' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/users'
    expect(status_code).to be 200
    expect(page).to have_content('Пользователи')
  end

  it 'new' do
    visit '/backend/users/new'
    expect(status_code).to be 200
    expect(page).to have_content('Пользователи')
  end

  describe 'изменение' do
    let(:user) { FactoryGirl.create(:user) }

    it 'edit' do
      visit "/backend/users/#{user.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Пользователи')
    end

  end

end