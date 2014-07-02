# -*- coding: utf-8 -*-
class Backend::TransfersController < Backend::ContentController
  before_filter :set_persons, :set_teams, only: [:new, :edit, :update]
  before_filter :set_transfer, :set_teams, only: [:edit, :update, :destroy]

  # GET /backend/transfers(.:format)
  def index 
    @transfers = Transfer.not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: "start_at DESC")
    @transfers = @transfers.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/transfers/new(.:format)
  def new
    @transfer = Transfer.new
  end

  # POST /backend/transfers(.:format)
  def create
    @transfer = Transfer.new(params[:transfer])
    if @transfer.save
      create_successful
    else
      render :new
      create_failed
    end
  end

  # GET /backend/transfers/:id/edit(.:format)
  def edit;end

  # PUT /backend/transfers/:id(.:format)
  def update
    if @transfer.update_attributes(params[:transfer])
      update_successful
    else
      render :edit
      update_failed
    end
  end

  # DELETE /backend/transfers/:id(.:format)
  def destroy
    @transfer.toggle!(:is_deleted)
    @transfer.update_attribute(:is_published, false)
    destroy_successful
  end

private

  def set_persons
    @persons = Person.all
  end

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def set_teams
    @teams = Team.all
  end

end
