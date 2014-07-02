# -*- coding: utf-8 -*-
class UnlocksController < Devise::UnlocksController
  skip_before_filter :get_main_news
  layout 'application'

  # POST /resource/unlock
  def create
    self.resource = resource_class.find_by_email(resource_params[:email]).first

    if self.resource && self.resource.locked_at
      if self.resource.unlock_token
        resource_class.send_unlock_instructions(resource_params)
        return redirect_to root_url, notice: "Инструкции по разблокировке высланы на #{resource.email}, проверьте почтовый ящик"
      else
        return redirect_to root_url, notice: 'Разблокировка невозможна'
      end
    else
      return redirect_to root_url, notice: 'Возможно, указан неверный Email адрес'
    end
  end

  # GET /resource/unlock?unlock_token=abcdef
  def show
    self.resource = resource_class.unlock_access_by_token(params[:unlock_token])
    if resource.errors.empty?
      sign_in(resource_name, resource)
      # session[:registration_attempts] = 0
      return redirect_to root_url, notice: 'Ваша учетная запись разблокирована'
    else
      redirect_to new_user_unlock_path
    end
  end

end