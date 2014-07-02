# encoding: utf-8
require 'spec_helper'

describe Backend::CharactersController do

  let(:character) { FactoryGirl.create(:character) }

  before :all do
    Character.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/characters/#{character.id}/edit" }.should route_to(
        controller: "backend/characters",
        action:     "edit",
        id:         character.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/characters/#{character.id}" }.should route_to(
        controller: "backend/characters",
        action:     "update",
        id:         character.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/characters/#{character.id}" }.should route_to(
        controller: "backend/characters",
        action:     "destroy",
        id:         character.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/characters/#{character.id}" }.should_not be_routable
    end

  end

end