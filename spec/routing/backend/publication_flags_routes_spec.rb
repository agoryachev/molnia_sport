# encoding: utf-8
require 'spec_helper'

describe Backend::PublicationFlagsController do

  let(:post) { FactoryGirl.create(:post) }

  before :all do
    Post.destroy_all
  end

  describe 'маршруты' do
    # Допустимые маршруты
    it ':update' do
      @pst = post
      { put: "backend/Post/#{@pst.id}/is_published" }.should route_to(
        controller: 'backend/publication_flags',
        action:     'update',
        name:       'Post',
        id:         @pst.id.to_s,
        field:      'is_published'
      )
    end

  end

end