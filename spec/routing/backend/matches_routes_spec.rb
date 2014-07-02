# encoding: utf-8
require 'spec_helper'

describe Backend::MatchesController do

  let(:match) { FactoryGirl.create(:match) }

  before :all do
    Match.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/matches/#{match.id}/edit" }.should route_to(
        controller: "backend/matches",
        action:     "edit",
        id:         match.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/matches/#{match.id}" }.should route_to(
        controller: "backend/matches",
        action:     "update",
        id:         match.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/matches/#{match.id}" }.should route_to(
        controller: "backend/matches",
        action:     "destroy",
        id:         match.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":index" do
      { get: "/backend/matches" }.should_not be_routable
    end
    it ":show" do
      { get: "/backend/matches/#{match.id}" }.should_not be_routable
    end

  end

end