# encoding: utf-8
require 'spec_helper'

describe Backend::LeaguesController do

  let(:league) { FactoryGirl.create(:league) }

  before :all do
    League.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":show"    do
      { get: "/backend/leagues/#{league.id}" }.should route_to(
        controller: "backend/leagues",
        action:     "show",
        id:         league.id.to_s
      )
    end
    it ":edit"    do
      { get: "/backend/leagues/#{league.id}/edit" }.should route_to(
        controller: "backend/leagues",
        action:     "edit",
        id:         league.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/leagues/#{league.id}" }.should route_to(
        controller: "backend/leagues",
        action:     "update",
        id:         league.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/leagues/#{league.id}" }.should route_to(
        controller: "backend/leagues",
        action:     "destroy",
        id:         league.id.to_s
      )
    end

    it ":update_years" do
      { post: "/backend/leagues/#{league.id}/2006/update_years" }.should route_to(
        controller: "backend/leagues",
        action:     "update_years",
        id:         league.id.to_s,
        year:       "2006"
      )
    end

    # Недопустимые маршруты
    it ":create" do
      { post: "/backend/leagues" }.should_not be_routable
    end

  end

end