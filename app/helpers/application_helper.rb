module ApplicationHelper
  # Выводи список тегов через запятую
  # 
  # @param tags [Array] массив тегов
  # @return [String] строка тегов обернутых в ссылку
  #
  def tag_link(tags)
    tags.map { |tag| link_to tag, tag_path(tag: tag) }.join(', ')
  end

  # Выводи блок 'спорт сегодня' с тегами за последние сутки в сайдбаре,
  # если тегов не найдено, блок не отображается
  #
  # @return [HTML] html блок
  #
  def sport_today_block
    if popular_tags.present?
      haml_tag :article, class: 'side_pad side_tags' do
        haml_tag :h3, 'СПОРТ СЕГОДНЯ', class: 'side_title'
        haml_tag :div, class: :list do
          haml_tag :p do
            haml_concat(simple_format popular_tags)
          end
        end
      end
    end
  end

  # Метод проверяет url строку, если там есть категория,
  # то ищет теги по этой категории, если нет то берет все теги
  #
  # @return [HTML] html строка тегов обернутых в ссылки
  #
  def popular_tags
    if (matched = /categories\/(\d+)/.match(request.env['REQUEST_URI']))
      tag_links_for_tags_in_sidebar(Post.get_tags_for_sidebar(matched[1]))
    else
      tag_links_for_tags_in_sidebar(Post.get_tags_for_sidebar)
    end
  end

  # Проходит по массиву переданных тегов,
  # оборачивает каждый в ссылку
  #
  # @param tags [Array] массив тегов
  # @return [HTML] html строка тегов обернутых в ссылки
  #
  def tag_links_for_tags_in_sidebar(tags)
    tags.map{ |tag| link_to tag.tag_name, tag_path(tag: tag.tag_name) }.join(' / ')
  end

  # Показывает изображение модели
  # 
  # @param model [Object] модель у которой есть main_image
  # @param size [String] строка размеров изображения по умолчанию "90x90"
  # @return [String] изображение
  #
  def show_main_image(model, size = "90x90", alt = 'Спортивный сайт', class_name = 'main_image')
    if model.try(:main_image)
      image_tag model.main_image.url("_#{size}"), size: size, alt: alt, class: class_name
    else
      image_tag "missing/#{model.class.name.downcase}/_#{size}.jpg", size: size, alt: alt, class: class_name
    end
  end

  # Делает активным пункт меню в зависимости от ситуации
  # 
  # @param category [Object] категория пункта меню
  # @return [String] строка с классами
  #
  def active_nav(category)
    current_page?(category_path(category)) && 'active show-inner'  ||  @category.present? && @category.id == category.id && 'active show-inner'  || params[:category_id].to_i == category.id && 'active show-inner'
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end
end
