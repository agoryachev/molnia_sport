# -*- coding: utf-8 -*-
class Backend::PersonsController < Backend::ContentController
  before_filter :set_person, only: %i(edit update destroy)

  # GET backend/persons
  def index
    if params[:search].present?
      @persons = Person.search(params[:search])
      return @persons
    else
      @persons = Person.not_deleted.paginate(page: params[:page], limit: Setting.records_per_page, order: :name_first)
      @persons = @persons.where(is_published: params[:is_published]) if params[:is_published]
    end
  end

  # GET backend/persons/new
  def new
    # ВНИМАНИЕ: мы не используем экшен create, вместо этого
    # сразу создается модель, которая затем обрабатывается 
    # экшеном update (модель содержит медиа данные, для работы
    # с которыми нужен первичный ключ объекта)
    @person = find_or_create_obj(:person)
    build_media
    build_seo
  end

  # GET backend/persons/:id/edit
  def edit
    build_media
    build_seo
  end

  # PUT /backend/persons/:id
  def update
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :person).to_json) and return
    end

    if @person.update_attributes(params[:person])
      clear_session(:person)
      update_successful
    else
      build_seo
      update_failed
    end
  end

  # DELETE /backend/persons/:id
  def destroy
    @person.toggle!(:is_deleted)
    @person.update_attribute(:is_published, false)
    clear_session_by_id(@person)
    destroy_successful
  end

  # XHR /backend/persons/get_persons_for_select
  def get_persons_for_select
    if params[:query].present?
      persons = Person.search_by_name_or_last_name(params[:query]).select([:id, :name_first, :name_last]).order(:name_first)
      render json: persons, root: false
    else
      person = Person.includes(:main_image).find(params[:id])
      main_image = if person.main_image.present? then person.main_image.url("_90x90") else '/assets/missing/_90x90.jpg' end
      render json: {id: person.id, name_first:person.name_first, name_last: person.name_last, main_image: main_image, content: person.content }, root: false
    end
  end

  # XHR /backend/persons/get_referees_for_select
  def get_referees_for_select
    if params[:query].present?
      persons = Person
                  .search_by_name_or_last_name(params[:query])
                  .select([:id, :name_first, :name_last])
                  .order(:name_first)
                  .referees
      render json: persons, root: false
    else
      person = Person
                  .includes(:main_image)
                  .find(params[:id])
                  .referees
      main_image = if person.main_image.present? then person.main_image.url("_90x90") else '/assets/missing/_90x90.jpg' end
      render json: {id: person.id, name_first:person.name_first, name_last: person.name_last, main_image: main_image, content: person.content }, root: false
    end
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def build_seo
    @seo = @person.build_seo unless @person.seo.present?
  end

  def build_media
    @person.build_main_image if @person.main_image.nil?
  end
end
