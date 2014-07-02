module Redirects
  extend ActiveSupport::Concern

  # Методы редиректы для контроллеров
  # Примеры:
  #
  # Конроллер
  # 
  #    Backend::PostsController
  #
  # в нем есть методы create, update, destroy
  #
  # если один из url'ов похож на
  # 
  #    backend_posts_url
  #    edit_backend_posts_url
  #    new_backend_posts_url
  # 
  # то есть не вложенный в другую модель, для того чтобы
  # правильно сослаться на нужный url надо вызвать один из методов
  #
  # например:
  #
  # если на странице была нажата кнопка сохранить и выйти
  # для получения backend_posts_url
  # 
  # надо вызвать метод  
  #    => create_successful
  #
  # если на странице была нажато просто сохранить
  # для получения edit_backend_post_url
  # 
  # надо вызвать метод 
  #    => create_successful
  # 
  # если произошла ошибка при создании модели
  # 
  # надо вызвать метод
  #    => create_fail
  # 
  # так же при обновлении модели надо вызвать методы алиасы
  # 
  #    => update_successful
  #    => update_fail
  # 
  # 
  # Конроллер
  # 
  #    Backend::ColumnistPostsController
  # 
  # в нем есть методы create, update, destroy
  #
  # если один из url'ов похож на
  # 
  #    backend_columnist_columnist_posts
  #    new_backend_columnist_columnist_post
  #    edit_backend_columnist_columnist_post
  # 
  # это вложенный конроллер и зависит от модели columnist
  # соответственно для генерации url'ов надо передать в методы
  # модель @columnist, в данном примере она берется из @columnist_post.columnist
  # 
  #    => create_successful(@columnist_post.columnist)
  #    => update_successful(@columnist_post.columnist)
  # 
  # в методы 
  # 
  #    => create_fail
  #    => update_fail
  # 
  # передавать нечего не надо
  # 
  # def create
  #   @video = Video.new(params[:video])
  #   if @video.save
  #     create_successful
  #   else
  #     create_failed
  #   end
  # end
  # 
  # def update
  #   if @video.update_attributes(params[:video])
  #     update_successful
  #   else
  #     update_failed
  #   end
  # end
  # 
  # def destroy
  #   @video.destroy
  #   destroy_successful
  # end



  included do
    # Метод обертка над методом redirect_successful
    # 
    # @param model [Object] модель которая передается в метод redirect_successful
    #
    def create_successful(submodel = nil, custom_path = nil)
      redirect_successful(submodel, custom_path)
    end

    # Метод обертка над методом redirect_successful
    # 
    # @param model [Object] модель которая передается в метод redirect_successful
    #
    def update_successful(submodel = nil, custom_path = nil)
      redirect_successful(submodel, custom_path)
    end

    # Метод обертка над методом failed
    # 
    # @param model [Object] модель которая передается в метод failed
    #
    def create_failed
      failed(:new)
    end

    # Метод обертка над методом failed
    # 
    # @param model [Object] модель которая передается в метод failed
    #
    def update_failed
      failed(:edit)
    end

    # Перенаправление при удачном обновлении
    # @param model [Object] модель
    #
    def redirect_successful(submodel, custom_path)
      respond_to do |format|
        flash[:notice] = t("msg.saved")
        format.html { custom_path } && return if custom_path
        if params[:commit] == t("label.save_and_exit")
          format.html { redirect_to to_route(self.class.name, submodel) }
        else
          route = [:edit] << to_route(self.class.name).first << submodel << get_instance_var(self.class.name)
          format.html { redirect_to route }
        end
      end
    end

    # Сообщение, в случае ошибки или если действие не может быть выполнено
    # 
    # @param model [Object] модель в которой произошла ошибка
    # @return flash [String] строка сообщения об ошибке
    # @return errors [Hash] hash с полным сообщением об ошибке
    #
    def failed(view)
      @errors = get_instance_var(self.class.name).errors.full_messages
      flash[:error] = t("msg.save_error")
      render view
    end

    # Сообщение об успешном удаление позиции
    #
    # @param model [Object] модель в которой произошла ошибка
    # @return flash [String] строка сообщения об ошибке
    #
    def destroy_successful(submodel = nil, custom_path = nil)
      respond_to do |format|
        flash[:notice] = t("msg.deleted")
        if custom_path.nil?
          format.html { redirect_to to_route(self.class.name, submodel) }
        else
          format.html { redirect_to custom_path }
        end
      end
    end
  end

  def prepare_string(string)
    string
      .gsub(/Controller$/, '')                  # PostsController => Posts
      .gsub(/([A-z]+)([A-Z][a-z])/, '\1_\2')    # FooBar => Foo_Bar
      .downcase
  end

  def get_instance_var(string)
    string = prepare_string(string)
    controller_name = if /::/.match(string) then string.split("::")[1] else string end
    instance_variable_get("@#{controller_name.singularize}")
  end

  def to_route(string, submodel = nil)
    string = prepare_string(string)
    if /::/.match(string)
      module_name, controller_name = string.split("::")
      return [module_name.to_sym, submodel, controller_name.to_sym]
    else
      # TODO проверить как будет работать без префикса модуля(::Backend)
      return [string, submodel]
    end
  end
end