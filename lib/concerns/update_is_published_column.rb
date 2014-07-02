module UpdateIsPublishedColumn
  extend ActiveSupport::Concern

  # Модуль для обновления поля is_published у модели
  # инклюдится в контроллер, потом в методе вызывается
  # update_published_column(@post) && return if request.xhr?

  included do
    # Обновление поля is_published, is_deleted
    # 
    # @param model [Object] модель в которой надо обновить поле
    # @return [Json] сообщение статус о обновлении
    #
    def update_published_column(model)
      return false unless @current_employee.can_update_flags?
      render json: if update_is_published(model)
        {msgs: t('msg.saved'), id: model.id}
      else
        {errors: t('msg.save_error')}
      end
    end
  end

private
  # метод переводящий класс в символ
  # 
  # @param model [Object] модель из которой надо получить символ Page -> :page
  # @return symbol [Symbol] символ
  #
  def class_to_sym(model)
    model.class.name.downcase.to_sym
  end

  # Обновление поля is_published у модели
  # 
  # @param model [Object] модель у которой надо обновить поле is_published
  # @return model [Object] модель с обновленным полем
  #
  def update_is_published(model)
    param = params[class_to_sym(model)]
    model.toggle!(param.keys.pop.to_sym)
  end
end