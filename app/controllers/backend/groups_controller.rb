# -*- coding: utf-8 -*-
class Backend::GroupsController < Backend::BackendController
  before_filter :set_abilities
  before_filter :set_group, only: [:update, :destroy]

  # GET /backend/groups
  def index
    @groups = Group.paginate(page: params[:page], order: "title", limit: 20)
  end

  # GET /backend/groups/new
  def new
    @group = Group.new
  end

  # POST /backend/groups
  def create
    @group = Group.new(params[:group])
    if @group.save 
      create_successful
    else
      create_failed
    end
  end

  # GET /backend/groups/:id
  def edit
    @group = Group.includes(:abilities).find(params[:id])
  end

  # PUT /backend/groups/:id
  def update  
    if @group.update_attributes(params[:group])
      update_successful
    else
      update_failed
    end
  end

  # DELETE /backend/groups/:id
  def destroy
    @group.destroy
    destroy_successful
  end 

private
  
  def set_abilities
    @abilities = Ability.order(:ability_type, :context).group_by{ |ability| ability.context.split('.').second }
  end

  def set_group
    @group = Group.find(params[:id])
  end

end