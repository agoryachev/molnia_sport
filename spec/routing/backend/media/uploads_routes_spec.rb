# encoding: utf-8
require 'spec_helper'

describe Backend::Media::UploadsController do

  let(:media_file) { FactoryGirl.create(:media_file) }

  before :all do
    MediaFile.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"     do get :index end
    it ":uploader"    do
      { get: "/backend/media/uploader" }.should route_to(
        controller: "backend/media/uploads",
        action:     "uploader"
      )
    end
    it ":uploader_tinymce"    do
      { get: "/backend/media/uploader_tinymce" }.should route_to(
        controller: "backend/media/uploads",
        action:     "uploader_tinymce"
      )
    end
    it ":action"    do
      { get: "/backend/media/dir/init" }.should route_to(
        controller: "backend/media/uploads",
        action:     "action",
        type:       "dir",
        act:        "init"
      )
    end

  end

end