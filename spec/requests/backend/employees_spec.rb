# encoding: utf-8
require 'spec_helper'

describe 'Сотрудники' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/employees'
    expect(status_code).to be 200
    expect(page).to have_content('Сотрудники')
  end

  it 'new' do
    visit '/backend/employees/new'
    expect(status_code).to be 200
    expect(page).to have_content('Сотрудники')
  end

  describe 'изменение' do
    let(:employee) { Employee.last }

    it 'edit' do
      visit "/backend/employees/#{employee.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Сотрудники')
    end

  end

end