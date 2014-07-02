# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController 
  layout 'application'
  before_filter :set_last_posts
  skip_before_filter :get_main_news

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        return render json: {errors: { text: 'Успешная регистрация. Вам выслано письмо с подтверждением регистрации на сайте.' }, login: true}, layout: false
      else
        expire_data_after_sign_in!
        return render json: {errors: { text: 'Успешный вход' }, login: true}, layout: false
      end
    else
      clean_up_passwords resource
      errors = resource.errors.full_messages
      return render json: {errors: { text: t("msg.save_error"), errors: errors }}, layout: false
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      sign_in resource_name, resource, bypass: true
      return render json: {errors: { text: 'Данные обновлены'}}, layout: false
    else
      clean_up_passwords resource
      errors = resource.errors.full_messages
      return render json: {errors: { text: 'Данные обновлены', errors: errors }}, layout: false
    end
  end

  private

  def set_last_posts
    @last_five_posts = Post.includes(:seo, :main_image, category:[:seo]).not_deleted.is_published.order("created_at DESC").limit(5)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end
end