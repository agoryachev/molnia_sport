# encoding: utf-8
require 'spec_helper'

describe Backend::PagesController do

  let(:page) { FactoryGirl.create(:page) }

  before :all do
    Page.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/pages/#{page.id}/edit" }.should route_to(
        controller: "backend/pages",
        action:     "edit",
        id:         page.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/pages/#{page.id}" }.should route_to(
        controller: "backend/pages",
        action:     "update",
        id:         page.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/pages/#{page.id}" }.should route_to(
        controller: "backend/pages",
        action:     "destroy",
        id:         page.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/pages/#{page.id}" }.should_not be_routable
    end

  end

end