# -*- coding: utf-8 -*- 
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    process_callback
  end

  def vkontakte
    process_callback
  end

  def twitter
    process_callback
  end

  def process_callback
    @user = User.find_for_provider_oauth(omniauth_auth, current_user)
    unless @user.is_active?
      flash[:notice] = t('msg.user_not_active')
      return redirect_to root_url
    end
    if @user.persisted?
      sign_in @user, event: :authentication
    else
      flash[:notice] = t('msg.oauth_error')
      session["devise.#{omniauth_auth.provider}_data"] = omniauth_auth
      redirect_to root_url
      return
    end
    flash[:notice] = t('msg.omniauth_callbacks_success')
    redirect_to path
  end

  # Возвращает путь для возврата в точку, где началась аутентификация
  # 
  # @return path [String]
  #
  def path
    if request.env["omniauth.origin"]
      request.env["omniauth.origin"]
    elsif session[:back_path]
      session[:back_path]
    else
      root_url
    end
  end

  def omniauth_auth
    request.env["omniauth.auth"]
  end

end