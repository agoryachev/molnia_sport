# -*- coding: utf-8 -*-
class Backend::UsersController < Backend::ContentController
  before_filter :set_user, only: [:edit, :update, :destroy]

  # GET /backend/users
  def index
    @users = if params['search'].nil?
      User.paginate(page: params[:page], order: "created_at DESC", limit: Setting.records_per_page)
    else
      User.search(params[:search])
    end
    return @users
  end

  # GET /backend/new
  def new
    @user = find_or_create_obj(:user)
    build_media
  end

  # POST /backend/users
  def create
    @user = User.new(params[:user])
    @user.skip_confirmation!
    if @user.save
      clear_session(:user)
      create_successful
    else
      render :new
      create_failed
    end
  end

  # GET /backend/users/:id/edit
  def edit
    build_media
  end

  # PUT /backend/users/:id
  def update
    if params["_plupload_upload"]
      render(json: asynch_upload(params, :user).to_json) && return
    end

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].except!(:password, :password_confirmation)
    end
    if @user.update_attributes(params[:user])
      clear_session(:user)
      update_successful
    else
      update_failed
    end
  end
  
  # DELETE /backend/users/:id
  def destroy
    @user.destroy
    clear_session_by_id(@user)
    destroy_successful
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def build_media
    @user.build_main_image if @user.main_image.nil?
  end
end