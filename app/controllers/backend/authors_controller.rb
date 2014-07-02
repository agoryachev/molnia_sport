# -*- coding: utf-8 -*-
class Backend::AuthorsController < Backend::BackendController
  before_filter :set_employees
  before_filter :set_author, only: [:edit, :update, :destroy]
  
  # GET /backend/authors
  def index 
    @authors = Author.includes(:employee).order(:name)
    if params[:search]
      @authors = Author.search(params[:search]).order(:name)
      return @authors
    else
      @authors = @authors.paginate(page: params[:page], order: 'name', limit: 20)
    end
  end

  # GET /backend/authors/new
  def new
    @author = Author.new
  end

  # POST /backend/authors
  def create
    @author = Author.new(params[:author])
    if @author.save
      create_successful
    else
      create_failed
      render :new
    end
  end

  # GET /backend/authors/:id/edit
  def edit;end


  # PUT /backend/authors/:id
  def update
    if @author.update_attributes(params[:author])
      update_successful
    else
      update_failed
      render :edit
    end
  end

  # DELETE /backend/authors/:id
  def destroy
    @author.destroy
    destroy_successful
  end
  
private
  
  def set_author
    @author = Author.find(params[:id])  
  end

  def set_employees
    @employees = Employee.select([:id, :name_first, :name_last]).map{|e| ["#{e.name_last} #{e.name_first}", e.id]}
  end
  
end
