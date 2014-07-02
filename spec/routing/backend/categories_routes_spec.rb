# encoding: utf-8
require 'spec_helper'

describe Backend::CategoriesController do

  let(:category) { FactoryGirl.create(:category) }

  before :all do
    Category.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":sort"    do post :sort end
    it ":edit"    do
      { get: "/backend/categories/#{category.id}/edit" }.should route_to(
        controller: "backend/categories",
        action:     "edit",
        id:         category.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/categories/#{category.id}" }.should route_to(
        controller: "backend/categories",
        action:     "update",
        id:         category.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/categories/#{category.id}" }.should route_to(
        controller: "backend/categories",
        action:     "destroy",
        id:         category.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/categories/#{category.id}" }.should_not be_routable
    end

  end

end