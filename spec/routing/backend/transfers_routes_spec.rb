# encoding: utf-8
require 'spec_helper'

describe Backend::TransfersController do

  let(:transfer) { FactoryGirl.create(:transfer) }

  before :all do
    Transfer.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/transfers/#{transfer.id}/edit" }.should route_to(
        controller: "backend/transfers",
        action:     "edit",
        id:         transfer.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/transfers/#{transfer.id}" }.should route_to(
        controller: "backend/transfers",
        action:     "update",
        id:         transfer.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/transfers/#{transfer.id}" }.should route_to(
        controller: "backend/transfers",
        action:     "destroy",
        id:         transfer.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/transfers/#{transfer.id}" }.should_not be_routable
    end

  end

end