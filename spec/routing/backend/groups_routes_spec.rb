# encoding: utf-8
require 'spec_helper'

describe Backend::GroupsController do

  let(:group) { FactoryGirl.create(:group) }

  before :all do
    Group.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/groups/#{group.id}/edit" }.should route_to(
        controller: "backend/groups",
        action:     "edit",
        id:         group.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/groups/#{group.id}" }.should route_to(
        controller: "backend/groups",
        action:     "update",
        id:         group.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/groups/#{group.id}" }.should route_to(
        controller: "backend/groups",
        action:     "destroy",
        id:         group.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/groups/#{group.id}" }.should_not be_routable
    end

  end

end