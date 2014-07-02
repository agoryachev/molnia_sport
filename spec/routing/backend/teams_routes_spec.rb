# encoding: utf-8
require 'spec_helper'

describe Backend::TeamsController do

  let(:team) { FactoryGirl.create(:team) }

  before :all do
    Team.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":edit"    do
      { get: "/backend/teams/#{team.id}/edit" }.should route_to(
        controller: "backend/teams",
        action:     "edit",
        id:         team.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/teams/#{team.id}" }.should route_to(
        controller: "backend/teams",
        action:     "update",
        id:         team.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/teams/#{team.id}" }.should route_to(
        controller: "backend/teams",
        action:     "destroy",
        id:         team.id.to_s
      )
    end
    it ":get_teams_for_select" do
      { get: "/backend/teams/get_teams_for_select" }.should route_to(
        controller: "backend/teams",
        action:     "get_teams_for_select"
      )
    end

    # Недопустимые маршруты
    it ":create" do
      { post: "/backend/teams" }.should_not be_routable
    end
    it ":show" do
      { get: "/backend/teams/#{team.id}" }.should_not be_routable
    end

  end

end