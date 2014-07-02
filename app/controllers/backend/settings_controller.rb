# -*- coding: utf-8 -*-
class Backend::SettingsController < Backend::ContentController

  # Список настроек
  # GET /backend/settings
  def index
    @settings = Setting.all
  end

  # Форма редактирования настройки
  # GET /backend/settings/:id/edit
  def edit
    @setting = Setting.find(params[:id])
  end

  # Обновление настройки
  # PUT /backend/settings/:id
  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      update_successful
    else
      update_failed
    end
  end

end