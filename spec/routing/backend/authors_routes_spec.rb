# encoding: utf-8
require 'spec_helper'

describe Backend::AuthorsController do

  let(:author) { FactoryGirl.create(:author) }

  before :all do
    Author.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/authors/#{author.id}/edit" }.should route_to(
        controller: "backend/authors",
        action:     "edit",
        id:         author.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/authors/#{author.id}" }.should route_to(
        controller: "backend/authors",
        action:     "update",
        id:         author.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/authors/#{author.id}" }.should route_to(
        controller: "backend/authors",
        action:     "destroy",
        id:         author.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/authors/#{author.id}" }.should_not be_routable
    end

  end

end