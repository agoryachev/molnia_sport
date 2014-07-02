# encoding: utf-8
require 'spec_helper'

describe 'Главная страница' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend'
    expect(status_code).to be 200
    expect(page).to have_content('Последние новости')
  end

end