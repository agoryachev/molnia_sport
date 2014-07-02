# encoding: utf-8
require 'spec_helper'

describe 'Галлереи' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_gallery) { FactoryGirl.create(:gallery) }

    it do
      visit "/categories/#{new_gallery.category.id}/galleries/#{new_gallery.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.galleries-for-specs')
    end
  end
end