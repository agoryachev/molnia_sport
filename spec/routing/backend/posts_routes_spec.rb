# encoding: utf-8
require 'spec_helper'

describe Backend::PostsController do
  
  let(:news) { FactoryGirl.create(:post) }

  before :all do
    Post.destroy_all
  end
  
  describe "маршруты" do

    # Допустимые маршруты
    it ":index"       do get :index end
    it ":new"         do get :new end
    it ":edit"   do
      { get: "/backend/posts/#{news.id}/edit" }.should route_to(
        controller: "backend/posts",
        action:     "edit",
        id:         news.id.to_s
      )
    end
    it ":update" do
      { put: "/backend/posts/#{news.id}" }.should route_to(
        controller: "backend/posts",
        action:     "update",
        id:         news.id.to_s
      )
    end
    it ":destroy" do
      { delete: "/backend/posts/#{news.id}" }.should route_to(
        controller: "backend/posts",
        action:     "destroy",
        id:         news.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/posts/#{news.id}" }.should_not be_routable
    end
    it ":create" do
      { post: "/backend/posts" }.should_not be_routable
    end

  end

end