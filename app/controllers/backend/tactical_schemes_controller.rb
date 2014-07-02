# -*- coding: utf-8 -*-
class Backend::TacticalSchemesController < Backend::ContentController

  before_filter :set_tactical_scheme, only: [:edit, :update, :destroy]

  # GET /backend/tactical_schemes
  def index
    @tactical_schemes = params[:search].present? ? 
      TacticalScheme.search(params[:search]).order(:updated_at).not_deleted : 
      TacticalScheme.order(:updated_at).not_deleted.paginate(page: params[:page], limit: Setting.records_per_page)
    @tactical_schemes = @tactical_schemes.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/tactical_schemes/new(.:format)
  def new
    @tactical_scheme = TacticalScheme.new
  end

  # POST backend/characters
  def create
    @tactical_scheme = TacticalScheme.new(params[:tactical_scheme])
    if @tactical_scheme.save
      create_successful
    else
      create_failed
    end
  end


  # GET /backend/tactical_schemes/:id/edit(.:format)
  def edit
  end

  # PUT /backend/tactical_schemes/:id(.:format)
  def update
    if @tactical_scheme.update_attributes(params[:tactical_scheme])
      update_successful
    else
      render :edit
      update_failed
    end
  end

  # DELETE /backend/tactical_schemes/:id(.:format)
  def destroy
    @tactical_scheme.toggle!(:is_deleted)
    @tactical_scheme.update_attribute(:is_published, false)
    clear_session_by_id(@tactical_scheme)
    destroy_successful
  end

  private

  def set_tactical_scheme
    @tactical_scheme = TacticalScheme.find(params[:id])
  end
end