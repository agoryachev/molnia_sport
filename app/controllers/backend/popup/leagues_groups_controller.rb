# -*- coding: utf-8 -*-
class Backend::Popup::LeaguesGroupsController < Backend::ContentController
  layout 'popup'

  # GET backend/popup/leagues_groups/new
  def new
    @leagues_group = LeaguesGroup.new
    build_seo
  end

  # POST backend/popup/leagues_groups/
  def create
    @leagues_group = LeaguesGroup.new(params[:leagues_group])
    if @leagues_group.save
      flash[:notice] = t("msg.saved")
      redirect_to [:edit, :backend, :popup, @leagues_group]
    else
      @errors = @leagues_group.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :new
    end
  end

  # GET backend/popup/leagues_groups/:id/edit
  def edit
    @leagues_group = LeaguesGroup.find(params[:id])
  end

  # PUT backend/popup/leagues_groups/:id
  def update
    @leagues_group = LeaguesGroup.find(params[:id])
    if @leagues_group.update_attributes(params[:leagues_group])
      flash[:notice] = t("msg.saved")
      redirect_to [:edit, :backend, :popup, @leagues_group]
    else
      @errors = @leagues_group.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :edit
    end
  end

  private

  def build_seo
    @seo = @leagues_group.build_seo unless @leagues_group.seo.present?
  end

end