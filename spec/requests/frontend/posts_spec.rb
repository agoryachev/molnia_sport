# encoding: utf-8
require 'spec_helper'

describe 'Посты' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_post) { FactoryGirl.create(:post) }

    it do
      visit "/categories/#{new_post.category.id}/posts/#{new_post.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.posts-for-specs')
    end
  end

  describe 'index' do
    it do
      search_tag = 'sport'
      visit "/tag/#{search_tag}"
      expect(status_code).to be 200
      expect(page).to have_selector('.posts-for-specs')
    end
  end
end