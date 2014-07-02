# -*- coding: utf-8 -*-
class Backend::CategoriesController < Backend::BackendController
  before_filter :set_category, only: [:edit, :update, :destroy]
  before_filter :set_categories, only: [:new, :edit, :update, :create]

  # GET backend/categories
  def index
    @categories = if params[:search].present?
      Category.search(params[:search][:title], order: :placement_index)
              .paginate(page: params[:page], limit: Setting.records_per_page)
    else
      Category.order(:placement_index)
              .paginate(page: params[:page], limit: Setting.records_per_page)
    end
  end

  # GET backend/categories/new
  def new
    @category = Category.new
    @category.placement_index = 1 + Category.maximum(:placement_index).to_i
    build_seo
  end

  # POST backend/categories
  def create
    @category = Category.new(params[:category])
    if @category.save
      create_successful
    else
      build_seo
      create_failed
    end
  end

  # GET backend/categories/:id/edit
  def edit
    build_seo
  end

  # PUT backend/categories/:id
  def update
    update_published_column(@category) and return if request.xhr?
    
    if @category.update_attributes(params[:category])
      update_successful
    else
      build_seo
      update_failed
    end
  end

  # DELETE backend/categories/:id
  def destroy
    @category.destroy
    destroy_successful
  end

  # XHR /backend/pages/sort
  # Приходит массив страниц
  def sort
    params[:category].each_with_index{ |id, index| Category.update_all({placement_index: index+1}, {id: id}) }
    render nothing: true
  end

private
  
  def set_category
    @category = Category.find(params[:id])
  end

  def set_categories
    @categories = Category.order(:placement_index)
  end

  def build_seo
    @seo = @category.build_seo unless @category.seo.present?
  end
end