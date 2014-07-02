# encoding: utf-8
class Backend::InsidesController < Backend::ContentController
  before_filter :set_inside, only: [:edit, :update, :destroy]

  # GET /backend/insides(.:format)
  def index
    @insides = Inside.includes(:inside_status)
                    .not_deleted
                    .paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC")
  end

  # GET /backend/insides/new(.:format)
  def new
    @inside = Inside.new
  end

  def create
    @inside = Inside.create(params[:inside])
    if @inside.save
      create_successful
    else
      create_failed
    end
  end

  # GET /backend/insides/:id/edit(.:format)
  def edit;end

  # PUT /backend/insides/:id(.:format)
  def update
    if @inside.update_attributes(params[:inside])
      update_successful
    else
      update_failed
    end
  end

  # DELETE /backend/insides/:id(.:format)
  def destroy
    @inside.toggle!(:is_deleted)
    @inside.update_attribute(:is_published, false)
    destroy_successful
  end

  private

  def set_inside
    @inside = Inside.find(params[:id])
  end

end
