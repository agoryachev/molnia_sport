# encoding: utf-8
require 'spec_helper'

describe 'Команды' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/teams'
    expect(status_code).to be 200
    expect(page).to have_content('Команды')
  end

  it 'new' do
    FactoryGirl.create(:category)
    visit '/backend/teams/new'
    expect(status_code).to be 200
    expect(page).to have_content('Команды')
  end

  describe 'изменение' do
    let(:team) { FactoryGirl.create(:team) }

    it 'edit' do
      visit "/backend/teams/#{team.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Команды')
    end

  end

end