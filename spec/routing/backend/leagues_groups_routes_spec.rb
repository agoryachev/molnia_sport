# encoding: utf-8
require 'spec_helper'

describe Backend::LeaguesGroupsController do

  let(:leagues_group) { FactoryGirl.create(:leagues_group) }

  before :all do
    LeaguesGroup.destroy_all
  end
  
  describe "маршруты /backend/leagues_groups" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/leagues_groups/#{leagues_group.id}/edit" }.should route_to(
        controller: "backend/leagues_groups",
        action:     "edit",
        id:         leagues_group.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/leagues_groups/#{leagues_group.id}" }.should route_to(
        controller: "backend/leagues_groups",
        action:     "update",
        id:         leagues_group.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/leagues_groups/#{leagues_group.id}" }.should route_to(
        controller: "backend/leagues_groups",
        action:     "destroy",
        id:         leagues_group.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/leagues_groups/#{leagues_group.id}" }.should_not be_routable
    end

  end

end