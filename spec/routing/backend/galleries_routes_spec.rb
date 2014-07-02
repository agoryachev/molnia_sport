# encoding: utf-8
require 'spec_helper'

describe Backend::GalleriesController do
  
  let(:gallery) { FactoryGirl.create(:gallery) }

  before :all do
    Gallery.destroy_all
  end
  
  describe "маршруты" do

    # Допустимые маршруты
    it ":index"       do get :index end
    it ":new"         do get :new end
    it ":edit"   do
      { get: "/backend/galleries/#{gallery.id}/edit" }.should route_to(
        controller: "backend/galleries",
        action:     "edit",
        id:         gallery.id.to_s
      )
    end
    it ":update" do
      { put: "/backend/galleries/#{gallery.id}" }.should route_to(
        controller: "backend/galleries",
        action:     "update",
        id:         gallery.id.to_s
      )
    end
    it ":destroy" do
      { delete: "/backend/galleries/#{gallery.id}" }.should route_to(
        controller: "backend/galleries",
        action:     "destroy",
        id:         gallery.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/posts/#{gallery.id}" }.should_not be_routable
    end
    it ":create" do
      { post: "/backend/posts" }.should_not be_routable
    end

  end

end