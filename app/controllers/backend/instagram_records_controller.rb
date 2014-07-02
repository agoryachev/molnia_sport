# encoding: utf-8
class Backend::InstagramRecordsController < Backend::ContentController
  before_filter :set_instagram_record, only: [:edit, :update, :destroy]

  # GET /backend/instagram_record(.:format)
  def index
    @instagram_records = InstagramRecord.paginate(page: params[:page], limit: Setting.records_per_page, order: "published_at DESC").not_deleted
    @instagram_records = @instagram_records.where(is_published: params[:is_published]) if params[:is_published]
  end

  # GET /backend/instagram_record/new(.:format)
  def new
    @instagram_record = find_or_create_obj(:instagram_record)
  end

  # GET /backend/instagram_record/:id/edit(.:format)
  def edit
  end

  # PUT /backend/instagram_record/:id(.:format)
  def update
    @instagram_record.link = params[:instagram_record][:link]
    if @instagram_record.valid? && @instagram_record.save
      clear_session(:instagram_record)
      create_successful
    else
      create_failed
    end
  end

  # DELETE /backend/instagram_record/:id(.:format)
  def destroy
    @instagram_record.toggle!(:is_deleted)
    @instagram_record.update_attribute(:is_published, false)
    clear_session_by_id(@instagram_record)
    destroy_successful
  end

  private

  def set_instagram_record
    @instagram_record = InstagramRecord.find(params[:id])
  end
end