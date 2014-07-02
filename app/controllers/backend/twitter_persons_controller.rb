# encoding: utf-8
class Backend::TwitterPersonsController < Backend::ContentController
  before_filter :set_twitter_person, only: [:edit, :update, :destroy]

  # GET /backend/twitter_persons(.:format)
  def index
    @twitter_persons = TwitterPerson.paginate(page: params[:page], limit: Setting.records_per_page, order: "created_at DESC")
  end

  # GET /backend/twitter_persons/new(.:format)
  def new
    @twitter_person = TwitterPerson.new
  end

  # POST /backend/twitter_persons
  def create
    @twitter_person = TwitterPerson.new
    update_twitter_person()
  end

  # GET /backend/twitter_persons/:id/edit(.:format)
  def edit
  end

  # PUT /backend/twitter_persons/:id(.:format)
  def update
    update_twitter_person()
  end

  # DELETE /backend/twitter_persons/:id(.:format)
  def destroy
    clear_session_by_id(@twitter_person)
    @twitter_person.destroy
    destroy_successful
  end

  private

  def update_twitter_person()
    @twitter_person.link = params[:twitter_person][:link]
    @twitter_person.name = @twitter_person.link.split('/').last.split('?').first
    if @twitter_person.valid? && @twitter_person.save
      clear_session(:twitter_person)
      create_successful
    else
      create_failed
    end
  end

  def set_twitter_person
    @twitter_person = TwitterPerson.find(params[:id])
  end
end