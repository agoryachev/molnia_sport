# -*- coding: utf-8 -*-
class Backend::TeamsController < Backend::ContentController
  before_filter :set_team, only: [:edit, :update, :destroy]

  # GET backend/teams
  def index
    if params[:search].present?
      @teams = Team.search(params[:search])
      return @teams
    else
      @teams = Team.paginate(page: params[:page], limit: Setting.records_per_page, order: 'title')
      @teams = @teams.where(is_published: params[:is_published]) if params[:is_published]
    end
  end

  # GET backend/teams/new
  def new
    @team = find_or_create_obj(:team)
    @categories = Category::categories_for_select
    build_media
    build_seo
  end

  # GET backend/teams/:id/edit
  def edit
    @categories = Category::categories_for_select
    build_seo
    build_media
  end

  # PUT /backend/teams/:id
  def update
    if params[:destroy_selected]
      params[:destroy_selected].each{|person| @team.persons.destroy(person) }
      return update_successful
    end
    update_published_column(@team) && return if request.xhr?
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :team).to_json) && return
    end

    if @team.update_attributes(params[:team])
      clear_session(:team)
      update_successful
    else
      @categories = Category::categories_for_select
      build_media
      update_failed
    end
  end

  # DELETE /backend/teams/:id
  def destroy
    @team.title = "_#{@team.title}"
    @teamsave
    @team.toggle!(:is_deleted)
    @team.update_attribute(:is_published, false)
    clear_session_by_id(@team)
    destroy_successful
  end

  # XHR backend/teams/get_teams_for_select
  def get_teams_for_select
    teams = Team.where("title LIKE ?", "%#{params[:query]}%")
    render json: teams, root: false
  end

  private

  def build_seo
    @seo = @team.build_seo unless @team.seo.present?
  end

  def build_media
    @team.build_main_image if @team.main_image.nil?
  end

  def set_team
    @team = Team.find(params[:id])
  end

end
