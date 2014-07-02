# encoding: utf-8
require 'spec_helper'

describe Backend::EmployeesController do

  let(:employee) { FactoryGirl.create(:employee) }

  before :all do
    Employee.destroy_all
  end
  
  describe "маршруты" do
    # Допустимые маршруты
    it ":index"   do get :index end
    it ":new"     do get :new end
    it ":create"  do post :create end
    it ":edit"    do
      { get: "/backend/employees/#{employee.id}/edit" }.should route_to(
        controller: "backend/employees",
        action:     "edit",
        id:         employee.id.to_s
      )
    end
    it ":update"    do
      { put: "/backend/employees/#{employee.id}" }.should route_to(
        controller: "backend/employees",
        action:     "update",
        id:         employee.id.to_s
      )
    end
    it ":destroy"    do
      { delete: "/backend/employees/#{employee.id}" }.should route_to(
        controller: "backend/employees",
        action:     "destroy",
        id:         employee.id.to_s
      )
    end

    # Недопустимые маршруты
    it ":show" do
      { get: "/backend/employees/#{employee.id}" }.should_not be_routable
    end

  end

end