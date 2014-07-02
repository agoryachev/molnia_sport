# encoding: utf-8
require 'spec_helper'

describe Backend::YearsController do

  let(:year) { FactoryGirl.create(:year) }
  let(:league) { FactoryGirl.create(:league) }

  before :all do
    Year.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/years/#{year.id}/edit" }.should route_to(
        controller: "backend/years",
        action:     "edit",
        id:         year.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/years/#{year.id}" }.should route_to(
        controller: "backend/years",
        action:     "update",
        id:         year.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/years/#{year.id}" }.should route_to(
        controller: "backend/years",
        action:     "destroy",
        id:         year.id.to_s
      )
    end
    it ":update_groups"    do
      { post: "/backend/years/#{year.id}/#{league.id}/update_groups" }.should route_to(
        controller: "backend/years",
        action:     "update_groups",
        id:         year.id.to_s,
        league:     league.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/years" }.should_not be_routable
    end
    it ":show" do
      { get: "/backend/years/#{year.id}" }.should_not be_routable
    end

  end

end