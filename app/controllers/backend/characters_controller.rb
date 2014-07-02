# -*- coding: utf-8 -*-
class Backend::CharactersController < Backend::BackendController
  before_filter :set_character, only: [:edit, :update, :destroy]

  # GET backend/characters
  def index
    if params[:search].present?
      @characters = Character.search(params[:search])
    else
      @characters = Character.paginate(page: params[:page], limit: Setting.records_per_page)
    end
  end

  # GET backend/characters/new
  def new
    @character = Character.new
  end

  # POST backend/characters
  def create
    @character = Character.new(params[:character])
    if @character.save
      create_successful
    else
      create_failed
    end
  end

  # GET backend/characters/:id/edit
  def edit;end

  # PUT backend/characters/:id
  def update
    if @character.update_attributes(params[:character])
      update_successful
    else
      update_failed
    end
  end

  # DELETE backend/characters/:id
  def destroy
    @character.destroy
    destroy_successful
  end

private
  
  def set_character
    @character = Character.find(params[:id])
  end
end