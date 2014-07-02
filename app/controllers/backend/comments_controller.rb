# -*- coding: utf-8 -*-
class Backend::CommentsController < Backend::ContentController
  before_filter :set_comment, only: [:edit, :update, :destroy]

  # GET /backend/comments
  def index
    @comments = Comments::Comment.includes(:commentable, :user)

    if params['filter'] && params['filter']['from'].present? && params['filter']['to'].present?
      @comments = @comments.where('comments.created_at BETWEEN ? AND ?',Time.parse(params['filter']['from']).utc.to_s(:db),Time.parse(params['filter']['to']).utc.to_s(:db))

      @total = @comments.present? ? @comments.total_entries : 0
    end

    @comments = @comments.paginate(page: params[:page], limit: 20, order: "created_at DESC" )
  end

  # GET /backend/comments/:id
  def edit;end

  # PUT /backend/comments/:id
  def update

    if @comment.update_attributes(params[:comment])
      update_successful
    else
      update_failed
    end  
  end

  # DELETE /backend/comments/:id
  def destroy
    @comment.destroy
    destroy_successful
  end

private

  def set_comment
    @comment = Comments::Comment.find(params[:id])
  end

end