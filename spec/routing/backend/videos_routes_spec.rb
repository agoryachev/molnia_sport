# encoding: utf-8
require 'spec_helper'

describe Backend::VideosController do

  let(:video) { FactoryGirl.create(:video) }

  before :all do
    Video.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/videos/#{video.id}/edit" }.should route_to(
        controller: "backend/videos",
        action:     "edit",
        id:         video.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/videos/#{video.id}" }.should route_to(
        controller: "backend/videos",
        action:     "update",
        id:         video.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/videos/#{video.id}" }.should route_to(
        controller: "backend/videos",
        action:     "destroy",
        id:         video.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/videos/#{video.id}" }.should_not be_routable
    end

  end

end