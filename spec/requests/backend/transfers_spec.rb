# encoding: utf-8
require 'spec_helper'

describe 'Трансферы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/transfers'
    expect(status_code).to be 200
    expect(page).to have_content('Трансферы')
  end

  it 'new' do
    visit '/backend/transfers/new'
    expect(status_code).to be 200
    expect(page).to have_content('Трансферы')
  end

  describe 'изменение' do
    let(:transfer) { FactoryGirl.create(:transfer) }

    it 'edit' do
      visit "/backend/transfers/#{transfer.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Трансферы')
    end

  end

end
