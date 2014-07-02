# encoding: utf-8
module Comments

  class CommentsController < ApplicationController
    before_filter :set_commentable_model, :authenticate_user!, only: :create

    def index
      comments = Comment.get_comments(params)
      render json: as_json(comments), root: false
    end

    # POST /comments
    def create
      comment = Comment.build_from(@commentable, current_user.id, params[:content])

      if comment.save
        comment.move_to_parent(params[:parent_id]) if params['parent_id'].present?

        if Setting.moderate_comment == 1
          render json: {msgs: t('msg.moderate_comment')}
        else
          render json: {comment: single_as_json(comment), msg: t('msg.saved')}, root: false
        end
      else
        render json: {errors: comment.errors.full_messages }
      end
    end

    # GET comments/:id/update_vote/:type
    def update_vote
      comment = Comment.find(params[:id])
      if params[:type] == 'like'
        return render json: {message: t('msg.voted'), likes: comment.cached_weighted_score} if current_user.like(comment)
      elsif params[:type] == 'dislike'
        return render json: {message: t('msg.voted'), likes: comment.cached_weighted_score} if current_user.dislike(comment)
      end
      return render json: {message: t('msg.voted'), likes: comment.cached_weighted_score} if current_user.voted?(comment)
    end

  private
    def set_commentable_model
      class_name = params[:commentable_type].to_s.classify.constantize
      @commentable = class_name.find_by_id(params[:commentable_id]) || not_found
    end

    def as_json(comments)
      liked = if current_user then current_user.likes_id(comments) else [] end
      comments.map{|comment| to_json(comment, liked) }
    end

    def single_as_json(comment)
      liked = if current_user then current_user.likes_id(comment) else [] end
      to_json(comment, liked)
    end

    def to_json(comment, liked)
      {
        id: comment.id,
        content: comment.content,
        parent_id: comment.parent_id,
        user_image: user_image(comment),
        likes: comment.cached_weighted_score,
        user_comment: user_comment?(comment),
        username: comment.try(:user).try(:full_name) || 'Аноним',
        depth: comment.depth,
        added_time: view_context.time_ago_in_words(comment.created_at)
      }
    end

    def user_image(comment)
      comment && comment.user ? comment.user.main_image.url('_60x60') : ''
    end

    def user_comment?(comment)
      current_user && comment.user && current_user.id === comment.user.id ? true : false
    end
  end
end
