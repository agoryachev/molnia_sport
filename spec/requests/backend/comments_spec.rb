# encoding: utf-8
require 'spec_helper'

describe 'Комментарии' do

  before(:each) do
    sign_in_as_valid_user_driver
  end

  it 'index' do
    visit '/backend/comments'
    expect(status_code).to be 200
    expect(page).to have_content('Комментарии')
  end

  describe 'изменение' do
    let(:comment) do
      comment = FactoryGirl.create(:comment)
      user =  FactoryGirl.create(:user)
      comment.user = user
      comment.save!
      comment
    end

    it 'edit' do
      visit "/backend/comments/#{comment.id}/edit"
      expect(status_code).to be 200
      expect(page).to have_content('Комментарии')
    end

  end

end