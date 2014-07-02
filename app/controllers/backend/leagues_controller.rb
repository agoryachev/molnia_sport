# -*- coding: utf-8 -*-
class Backend::LeaguesController < Backend::ContentController
  before_filter :set_categories, only: [:new, :edit, :update]
  before_filter :set_league,     only: [:edit, :update, :destroy]

  # GET /backend/leagues
  def index
    if params[:search].present?
      @leagues = League.search(params[:search])
      return @leagues
    end
    @leagues = if params[:year].present?
      League.search_by_year(params)
    else
      League
    end
    @leagues = @leagues.where(is_published: params[:is_published]) if params[:is_published]
    @leagues = @leagues.search_by_category(params) if params[:category_id].present?
    @leagues = @leagues.includes(:seo, :category, :country, :leagues_groups).not_deleted.paginate(page: params[:page], limit: Setting.records_per_page)
  end

  # GET /backend/leagues/:id(.:format)
  def show
    @league = League
                .select([:title, :id])
                .includes(:seo, :category, :country, :leagues_groups, :years)
                .find(params[:id])
    @years = @league.years.order("league_year DESC")
  end

  # GET /backend/leagues/new
  def new
    @league = find_or_create_obj(:league)
    build_seo
  end

  # GET /backend/leagues/new
  def edit
    build_seo
  end

  # PUT /backend/leagues/:id(.:format)
  def update
    if params[:league][:is_leagues_group_slider] == "1"
      ActiveRecord::Base.connection.execute('UPDATE `leagues` SET is_leagues_group_slider = 0')
    end
    update_published_column(@league) && return if request.xhr?
    if @league.update_attributes(params[:league])
      clear_session(:league)
      update_successful
    else
      update_failed
    end
  end

  # DELETE /backend/leagues/:id(.:format)
  def destroy
    @league.toggle!(:is_deleted)
    @league.update_attribute(:is_published, false)
    clear_session_by_id(@league)
    destroy_successful
  end

  # POST /backend/leagues/:id/:year/update_years(.:format)
  def update_years
    @years = League.find(params[:id]).years
    return @years, layout: false
  end

private

  def build_seo
    @seo = @league.build_seo unless @league.seo.present?
  end

  def set_categories
    @categories = Category.order(:placement_index)
  end

  def set_league
    @league = League.find(params[:id])
  end

end