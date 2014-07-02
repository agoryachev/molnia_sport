# encoding: utf-8
require 'spec_helper'

describe 'Группы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/groups'
    expect(status_code).to be 200
    expect(page).to have_content('Группы')
  end

  it 'new' do
    visit '/backend/groups/new'
    expect(status_code).to be 200
    expect(page).to have_content('Группы')
  end

  describe 'изменение' do
    let(:group) { FactoryGirl.create(:group) }

    it 'edit' do
      visit "/backend/groups/#{group.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Группы')
    end

  end

end
