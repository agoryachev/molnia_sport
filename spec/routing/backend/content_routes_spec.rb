# encoding: utf-8
require 'spec_helper'

describe Backend::ContentController do

  let(:author) { FactoryGirl.create(:author) }

  describe 'маршруты' do
    # Допустимые маршруты
    it ':index' do
      { get: "/backend/datatable/authors/#{author.id}/Author" }.should route_to(
        controller: 'backend/content',
        action:     'get_authors',
        id:         author.id.to_s,
        type:       'Author'
      )
    end

  end

end