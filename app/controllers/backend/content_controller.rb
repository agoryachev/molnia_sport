# encoding: utf-8
class Backend::ContentController < Backend::BackendController
  include Core::AsynchUploader
  skip_before_filter :check_employee_abilities!, only: :get_authors
  before_filter :sanitize_params, only: :update

  # Находит черновик или инициализирует объект
  #
  # * *Args*    :
  #   - +obj_sym+ -> Symbol название объекта-черновика (:post, :gallery, :video)
  #                         который кэшируется в сессии
  # * *Returns* :
  #   - object контент-объект: новости, галлерея, видео
  #
  def find_or_create_obj(obj_sym)
    obj_id = "#{obj_sym.to_s.downcase}_id"
    res = if session[:new] && session[:new][obj_id] != nil
      obj_sym.to_s.classify.constantize.find_by_id(session[:new][obj_id]) || obj_sym(obj_sym)
    else
      obj_sym(obj_sym)
    end
    session[:new] ||= {}
    session[:new][obj_id] = res.id
    res
  end

  # Находит существующий, либо создает новый черновик для запрошенной модели
  #
  # @param [Model] model - Константа, содержащая модель: Columnist или Person
  # @param [Hash] additions - Дополнительные параметры, которые могут быть необходимы методу создания черновика
  # @return [Object] - созданный или найденный черновик
  #
  def find_or_model(model, additions = nil)
    model_name = model.to_s.downcase
    model_name = "#{model_name}_#{additions[:columnist_id]}" if !additions.nil? && !additions[:columnist_id].nil?
    res = if session[:new] && session[:new]["#{model_name}_id"].present?
            model.find_by_id(session[:new]["#{model_name}_id"])
          else
            model.create_draft(additions) if model.respond_to?(:create_draft)
          end
    session[:new] ||= {}
    session[:new]["#{model_name}_id"] = res.id
    res
  end

  # Создание черновика
  #
  # * *Args*    :
  #   - +obj_sym+ -> Symbol название объекта-черновика (:post, :gallery, :video)
  #                         который кэшируется в сессии
  # * *Returns* :
  #   - object контент-объект: новости, галлерея, видео
  #
  def obj_sym(obj_sym)
    p = obj_sym.to_s.classify.constantize.new()
    p.title = "Черновик" if p.respond_to? :title

    p.nickname =   "Никнейм" if p.respond_to? :nickname
    p.name_first = "Имя" if p.respond_to? :name_first
    p.name_last =  "Фамилия" if p.respond_to? :name_last
    p.is_active =   false if p.respond_to? :is_active

    p.published_at =  Time.now if p.respond_to? :published_at
    p.started_at =  Time.now if p.respond_to? :started_at
    p.finished_at =  Time.now if p.respond_to? :finished_at
    p.employee_id = current_employee.id if p.respond_to? :employee_id
    p.category = Category.first if p.respond_to? :category
    p.person = Person.first if p.respond_to? :person
    p.start_at = Time.now if p.respond_to? :start_at
    p.finish_at = Time.now if p.respond_to? :finish_at
    p.save(validate: false)
    return p
  end

  # Чистим объект в сессии
  #
  # * *Args*    :
  #   - +obj_sym+ -> Symbol название объекта-черновика (:post, :gallery, :video)
  #                         который кэшируется в сессии
  # * *Returns* :
  #   - object контент-объект: новости, галлерея, видео
  #
  def clear_session(obj_sym)
    obj_id = "#{obj_sym.to_s.downcase}_id"
    session[:new][obj_id] = nil if session[:new] && session[:new][obj_id].present?
  end

  # После удаления статьи удаляем из сессии её идентификатор, если он совпадает с удаленным.
  #
  # * *Args*    :
  #   - +obj_sym+ -> Symbol название объекта-черновика (:post, :gallery, :video)
  #                         который кэшируется в сессии
  # * *Returns* :
  #   - object контент-объект: новости, галлерея, видео
  #
  def clear_session_by_id(obj_sym)
    obj_id = "#{obj_sym.class.to_s.downcase}_id"
    session[:new][obj_id] = nil if session[:new] && session[:new][obj_id].to_i == obj_sym.id
  end

  # Возвращает класс по заданному имени
  #
  # @param class_name [String] имя класса
  # @return [Class] найденный класс
  #
  def get_class(class_name)
    Kernel.const_get(class_name.classify)
  end

  # GET "/datatable/authors/:id/:type"
  def get_authors
    item = get_class(params[:type]).find_by_id(params[:id])
    render json: AuthorsDatatable.new(view_context, item.author_ids, params[:type])
  end

  # Дополнительные ограничения на права доступа is_published, :is_comments_enabled
  #
  # @return [Hash] params - параметры, поступающие к RoR из вне
  #
  def sanitize_params
    name = params[:controller].split('/').last.singularize
    params[name].except!(:is_published, :is_comments_enabled) if params[name].present? && !['match'].include?(name)
  end

end