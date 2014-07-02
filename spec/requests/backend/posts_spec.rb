# encoding: utf-8
require 'spec_helper'

describe 'Новости' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/posts'
    expect(status_code).to be 200
    expect(page).to have_content('Новости')
  end

  it 'new' do
    FactoryGirl.create(:category)
    visit '/backend/posts/new'
    expect(status_code).to be 200
    expect(page).to have_content('Новости')
  end

  describe 'изменение' do
    let(:post) { FactoryGirl.create(:post) }

    it 'edit' do
      visit "/backend/posts/#{post.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Новости')
    end

  end

end