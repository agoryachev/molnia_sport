# encoding: utf-8
require 'spec_helper'

describe Backend::UsersController do

  let(:user) { FactoryGirl.create(:user) }

  before :all do
    User.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/users/#{user.id}/edit" }.should route_to(
        controller: "backend/users",
        action:     "edit",
        id:         user.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/users/#{user.id}" }.should route_to(
        controller: "backend/users",
        action:     "update",
        id:         user.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/users/#{user.id}" }.should route_to(
        controller: "backend/users",
        action:     "destroy",
        id:         user.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/users/#{user.id}" }.should_not be_routable
    end

  end

end