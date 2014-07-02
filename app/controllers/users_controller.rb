# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_last_posts, on: :show

  # GET /users/show
  def show
    @comments = current_user.comments.includes(commentable: [:seo]).paginate(page: params[:page], limit: Setting.records_per_page).order("created_at DESC")
    @user = current_user
    @user.build_main_image if @user.main_image.nil?
    if request.xhr?
      return render 'show', layout: false
    end
  end

  def set_user
    render json: current_user, root: false
  end

  def update
    if current_user.update_attributes(params[:user].slice(:main_image_attributes))
      return render json: {errors: { notice: 'Фото обновлено' }, image: current_user.main_image.url("_100x100")}, layout: false
    else
      return render json: {errors: { alert: 'Ошибка при обновлениии попробуйте еще раз' }}, layout: false
    end
  end

private
  # Берет 5 последних новостей для вывода на старнице
  # 
  # @return last_five_posts [Object]
  #
  def set_last_posts
    @last_five_posts = Post.includes(:seo, :main_image, category:[:seo]).not_deleted.is_published.order("created_at DESC").limit(5)
  end

end
