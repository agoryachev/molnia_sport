# encoding: utf-8
require 'spec_helper'

describe Backend::PersonsController do

  let(:person) { FactoryGirl.create(:person) }

  before :all do
    Person.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":edit"    do
      { get: "/backend/persons/#{person.id}/edit" }.should route_to(
        controller: "backend/persons",
        action:     "edit",
        id:         person.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/persons/#{person.id}" }.should route_to(
        controller: "backend/persons",
        action:     "update",
        id:         person.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/persons/#{person.id}" }.should route_to(
        controller: "backend/persons",
        action:     "destroy",
        id:         person.id.to_s
      )
    end
    it ":get_persons_for_select" do
      { get: "/backend/persons/get_persons_for_select" }.should route_to(
        controller: "backend/persons",
        action:     "get_persons_for_select"
      )
    end

    # Недопустимые маршруты
    it ":create" do
      { post: "/backend/persons" }.should_not be_routable
    end
    it ":show" do
      { get: "/backend/persons/#{person.id}" }.should_not be_routable
    end

  end

end