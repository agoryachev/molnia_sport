# -*- coding: utf-8 -*-
class Backend::YearsController < Backend::ContentController
  before_filter :set_year, only: [:edit, :update, :update_year_from_modal, :destroy]

  # GET backend/years/new
  def new
    @year = Year.new
  end

  # POST backend/years/
  def create
    @year = Year.new(params[:year])
    if @year.save
      return render json: {notices: { text: t("msg.saved"), id: @year.id }}, layout: false
    else
      errors = @year.errors.full_messages
      return render json: {errors: { text: t("msg.save_error"), errors: errors }}, layout: false
    end
  end

  # GET backend/years/:id/edit
  def edit;end

  # PUT backend/years/:id
  def update
    if request.xhr?
      return update_year_from_modal
    end
    if @year.update_attributes(params[:year])
      update_successful
    else
      update_fail
    end
  end

  # DELETE backend/years/:id
  def destroy
    @year.destroy
    destroy_successful(nil, [:edit, :backend, @year.league])
  end

  # POST /backend/years/:id/:year/update_groups(.:format)
  def update_groups
    @leagues_groups = League.find(params[:league]).leagues_groups.where(year_id: params[:id])
    return @leagues_groups, layout: false
  end

  private

  def set_year
    @year = Year.find(params[:id])
  end

  def update_year_from_modal
    if @year.update_attributes(params[:year])
      return render json: {notices: { text: 'Успешно обновлено', id: @year.id }}, layout: false
    else
      errors = @year.errors.full_messages
      return render json: {errors: { text: t("msg.save_error"), errors: errors }}, layout: false
    end
  end
end
