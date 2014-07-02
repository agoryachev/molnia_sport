# encoding: utf-8
require 'spec_helper'

describe 'Колумнисты' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  describe 'show' do
    let(:new_employee)      { FactoryGirl.create(:employee) }
    let(:new_columnist)     { FactoryGirl.create(:columnist) }
    let(:columnist_post_1)  { FactoryGirl.create(:columnist_post, columnist_id: new_columnist.id, employee_id: new_employee.id) }
    let(:columnist_post_2)  { FactoryGirl.create(:columnist_post, columnist_id: new_columnist.id, employee_id: new_employee.id) }

    it do
      new_columnist.save
      visit "/columnists/#{new_columnist.id}"
      expect(status_code).to be 200
      expect(page).to have_selector('.columnists-for-specs')
    end
  end
end