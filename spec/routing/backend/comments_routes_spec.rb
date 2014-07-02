# encoding: utf-8
require 'spec_helper'

describe Backend::CommentsController do

  let(:comment) { FactoryGirl.create(:comment) }

  before :all do
    Comment.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":edit"    do
      { get: "/backend/comments/#{comment.id}/edit" }.should route_to(
        controller: "backend/comments",
        action:     "edit",
        id:         comment.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/comments/#{comment.id}" }.should route_to(
        controller: "backend/comments",
        action:     "update",
        id:         comment.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/comments/#{comment.id}" }.should route_to(
        controller: "backend/comments",
        action:     "destroy",
        id:         comment.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/comments/#{comment.id}" }.should_not be_routable
    end
    it ":new" do
      { get: "/backend/comments/new" }.should_not be_routable
    end
    it ":create" do
      { post: "/backend/comments/new" }.should_not be_routable
    end

  end

end