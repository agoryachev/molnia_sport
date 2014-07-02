module NewsListHelper
  # хелпер для вставки виджетов (главные новости, фото-видео, соц.сети и др) в блочную верстку основных страниц.
  # Виджеты вставляются правой колонкой.
  # Рассчитывается на какое текущее место вставляется новый блок, и если это правая колонка то в нее добавляется виджет из числа доступных.
  # Каждый виджет вставляется 1 раз.
  # Шаблоны виджет в структуре WIDGETS_MAPPING.
  # Порядок вставки, соответсвует порядку следования в WIDGETS_MAPPING.

  WIDGETS_MAPPING = {
    side_bar_main_news:   'shared/aside/top_news',
    side_bar_photo_video: 'shared/aside/photo_video_box',
    side_bar_socials:     'shared/aside/social_accordion',
    side_bar_columnists:  'shared/aside/columnists',
    sport_today:          'shared/aside/sport_today'
  }.freeze

  def get_render_column_element
    Render.new
  end

  class Render
    def initialize
      @mapping = WIDGETS_MAPPING.each
    end

    def call(index, &block)
      if !index.zero? and index%2 == 0
        key, partial = @mapping.next
        if (Setting.__send__(key) == '1' rescue true)
          block.call partial
        else
          call(index, &block)
        end
      end
    rescue StopIteration
    end
  end
end