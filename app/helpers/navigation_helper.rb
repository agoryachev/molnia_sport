module NavigationHelper
  # Выводит слайдер стран в меню для соответствующей категории
  #
  # @param category [Object] категория для которой надо вывести страны
  # @return [type] return_desc
  #
  def menu_slider(category)
    haml_tag :div, class: 'list-wrapper' do
      list(category)
    end
    controls
  end

  # Рендерит отдельную страну для слайдера
  #
  # @param category [Object] категория
  # @return [type] html
  #
  def list(category)
    haml_tag :ul, class: :list do
      category.countries.each do |country|
        haml_tag :li, class: li_class(category, country) && :active do
          haml_concat link_to country.title, [category, country]
        end
      end
    end
  end

  # Рендерит кнопки управления слайдером
  #
  # @return [type] html
  #
  def controls
    haml_tag :div, class: :controls do
      haml_tag :a, class: :prev, data: {dir: :prev}
      haml_tag :a, class: :next, data: {dir: :next}
    end
  end

  # Метод возвращающий класс active взависимости от параметров
  #
  # @param category [Object] категория
  # @param country [Object] страна
  #
  def li_class(category, country)
    current_page?([category, country])
  end

  # Последняя новость в категории для главной навигации
  #
  # @param category [Object] категория для которой надо вывести новость
  # @return [String] dom object
  #
  def menu_last_post(category)
    last_post = category.posts.is_published.last
    haml_tag :figure do
      haml_concat show_main_image last_post, '171x115', last_post.try(:title)
    end
    haml_tag :div, class: :content do
      haml_tag :h1 do
        haml_concat link_to last_post.try(:title), [category, last_post]
      end
      haml_tag :p do
        haml_concat category.posts.last.try(:subtitle)
      end
    end
  end

  # Выводит 4 последниx новостeй для категории
  #
  # @param category [Object] категория для которой надо вывести новости
  # @return [type] return_desc
  #
  def menu_last_articles(category)
    posts = category.posts.is_published.last(5)
    posts.pop
    haml_tag :ul do
      posts.each do |post|
        haml_tag :li do
          haml_tag :time do
            haml_concat post.created_at.strftime("%H:%m")
          end
          haml_concat link_to truncate(post.title, length: 55), [category, post], title: post.title
        end
      end
    end
  end

  # Выводит 10 последниx тегов для 100 последних новостей категории
  #
  # @param category [Object] категория для которой надо вывести теги
  # @return [type] return_desc
  #
  def menu_tags(category)
    tags = Post.get_last_tags(category.id)
    tags.map{ |tag| link_to tag.tag_name, tag_path(tag: tag.tag_name), class: :tag}.join('')
  end
end