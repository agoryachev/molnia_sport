# encoding: utf-8
require 'spec_helper'

describe 'Видеоролики' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/videos'
    expect(status_code).to be 200
    expect(page).to have_content('Видеоролики')
  end

  it 'new' do
    FactoryGirl.create(:category)
    visit '/backend/videos/new'
    expect(status_code).to be 200
    expect(page).to have_content('Видеоролики')
  end

  describe 'изменение' do
    let(:video) { FactoryGirl.create(:video) }

    it 'edit' do
      visit "/backend/videos/#{video.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Видеоролики')
    end

  end

end