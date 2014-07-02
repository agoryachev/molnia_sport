# -*- coding: utf-8 -*-
class SessionsController < Devise::SessionsController
  layout 'application'
  skip_before_filter :get_main_news
  before_filter :set_last_posts

  # POST /resource/create
  def create
    user = User.find_first_by_auth_conditions(login: params[:user][:login])
    if attempts_exceeds?
      lock_user_or_redirect_back(user)
    else
      session[:sign_in_attempts] ||= 1
      if user && user.valid_password?(params[:user][:password])
        return render json: {errors: { text: 'Ваша учетная запись заблокирована' }}, layout: false if user.locked?
        if user.confirmed?
          user.remember_me = true if params[:user][:remember_me].to_i == 1
          sign_in(:user, user)
          session[:sign_in_attempts] = nil
          cookies[:signed_in] = {value: 1, path: '/'}
          return render json: {errors: { text: 'Успешный вход' }, login: true}, layout: false
        else
          return render json: {errors: { text: 'Ваша учетная запись еще не активирована' }}, layout: false
        end
      else
        session[:sign_in_attempts] += 1
        return render json: {errors: { text: 'Неверный логин или пароль' }}, layout: false
      end
    end
  end

  # DELETE /resource
  def destroy
    cookies.delete :signed_in
    super
  end

private
  # Проветряет количесвто попыток входа в на сайт
  #
  # @return [Boolean]
  #
  def attempts_exceeds?
    !(session[:sign_in_attempts].nil? || 
      (session[:sign_in_attempts] && session[:sign_in_attempts] <= Setting.max_unsuccess_attempts))
  end

  # Берет 5 последних новостей для вывода на старнице
  # 
  # @return last_five_posts [Object]
  #
  def set_last_posts
    @last_five_posts = Post.includes(:seo, :main_image, category:[:seo]).not_deleted.is_published.order("created_at DESC").limit(5)
  end

  # Блокирует пользователя делает редирект назад с сообщением
  # 
  # @param user [Object] модель user
  #
  def lock_user_or_redirect_back(user)
    if user && !user.access_locked?
      user.lock_access!
      return render json: {errors: { text: 'Слишком много неудачных попыток, учетная запись заблокирована. Вам отправлено письмо с инструкциями по разблокировке.' }}, layout: false
    else
      return render json: {errors: { text: 'Слишком много неудачных попыток, попробуйте войти позже.' }}, layout: false
    end
  end
end