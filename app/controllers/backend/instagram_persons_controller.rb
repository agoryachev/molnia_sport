# encoding: utf-8
class Backend::InstagramPersonsController < Backend::ContentController
  before_filter :set_instagram_person, only: [:edit, :update, :destroy]

  # GET /backend/instagram_persons(.:format)
  def index
    @instagram_persons = InstagramPerson.paginate(page: params[:page], limit: Setting.records_per_page, order: "created_at DESC")
  end

  # GET /backend/instagram_persons/new(.:format)
  def new
    @instagram_person = InstagramPerson.new
  end

  # POST /backend/instagram_persons
  def create
    @instagram_person = InstagramPerson.new
    update_instagram_person()
  end

  # GET /backend/instagram_persons/:id/edit(.:format)
  def edit
  end

  # PUT /backend/instagram_persons/:id(.:format)
  def update
    update_instagram_person()
  end

  # DELETE /backend/instagram_persons/:id(.:format)
  def destroy
    clear_session_by_id(@instagram_person)
    @instagram_person.destroy
    destroy_successful
  end

  private

  def update_instagram_person()
    @instagram_person.link = params[:instagram_person][:link]
    @instagram_person.name = @instagram_person.link.split('/').last.split('?').first
    @instagram_person.insta_id = @instagram_person.link.split('/').last.split('?').first
    if @instagram_person.valid? && @instagram_person.save
      clear_session(:instagram_person)
      create_successful
    else
      create_failed
    end
  end

  def set_instagram_person
    @instagram_person = InstagramPerson.find(params[:id])
  end
end