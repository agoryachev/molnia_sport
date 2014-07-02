# -*- coding: utf-8 -*-
class Backend::EmployeesController < Backend::BackendController
  before_filter :set_groups
  before_filter :set_employee, only: [:show, :edit, :update, :destroy]

  # GET backend/employees
  def index
    @employees = if params[:search].present?
      Employee.search(params[:search])
    else
      Employee.includes(:group).paginate(page: params[:page], limit: 20, order: "nickname")
    end
  end

  # GET backend/employees/new
  def new
    @employee = Employee.new
  end

  # POST backend/employees/
  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      create_successful
    else
      create_failed
    end
  end

  # GET backend/employees/:id/edit
  def edit;end

  # PUT backend/employees/:id
  def update
    if params[:employee][:password].blank? && params[:employee][:password_confirmation].blank?
      params[:employee].except!(:password, :password_confirmation)
    end
    if @employee.update_attributes(params[:employee])
      update_successful
    else
      update_failed
    end
  end

  # DELETE backend/employees/1
  def destroy
    @employee.destroy  
    destroy_successful
  end

private
  
  def set_groups
    @groups = Group.select([:id,:title]).map { |e| [e.title,e.id] }
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end