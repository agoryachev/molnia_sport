# encoding: utf-8
require 'spec_helper'

describe Backend::CountriesController do

  let(:country) { FactoryGirl.create(:country) }

  before :all do
    Country.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/countries/#{country.id}/edit" }.should route_to(
        controller: "backend/countries",
        action:     "edit",
        id:         country.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/countries/#{country.id}" }.should route_to(
        controller: "backend/countries",
        action:     "update",
        id:         country.id.to_s
      )
    end
    it ":get_countries_for_ajax"    do
      { post: "/backend/countries/get_countries_for_ajax" }.should route_to(
        controller: "backend/countries",
        action:     "get_countries_for_ajax"
      )
    end
    it ":destroy"    do
      { delete: "/backend/countries/#{country.id}" }.should route_to(
        controller: "backend/countries",
        action:     "destroy",
        id:         country.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/countries/#{country.id}" }.should_not be_routable
    end

  end

end