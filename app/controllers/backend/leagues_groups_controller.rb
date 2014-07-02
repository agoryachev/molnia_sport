# -*- coding: utf-8 -*-
class Backend::LeaguesGroupsController < Backend::ContentController
  before_filter :set_leagues_group, only: [:edit, :update, :destroy]

  # GET backend/leagues_groups
  def index
    @leagues_groups = LeaguesGroup.paginate(page: params[:page], limit: Setting.records_per_page, order: 'created_at DESC')
  end

  # GET backend/leagues_groups/new
  def new
    @leagues_group = LeaguesGroup.new
    build_seo
  end

  # POST backend/leagues_groups/
  def create
    @leagues_group = LeaguesGroup.new(params[:leagues_group])
    if @leagues_group.save
      create_successful
    else
      create_failed
    end
  end

  # GET backend/leagues_groups/:id
  def edit;end

  # PUT backend/leagues_groups/:id
  def update
    if @leagues_group.update_attributes(params[:leagues_group])
      update_successful
    else
      update_failed
    end
  end

  # DELETE backend/leagues_groups/id
  def destroy
    @leagues_group.destroy
    destroy_successful
  end

  private

  def build_seo
    @seo = @leagues_group.build_seo unless @leagues_group.seo.present?
  end

  def set_leagues_group
    @leagues_group = LeaguesGroup.find(params[:id])
  end
end