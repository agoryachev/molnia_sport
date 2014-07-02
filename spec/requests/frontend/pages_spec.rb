# encoding: utf-8
require 'spec_helper'

describe 'Страницы' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_page) { FactoryGirl.create(:page) }

    it do
      visit "/pages/#{new_page.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.pages-for-specs')
    end
  end
end