# -*- coding: utf-8 -*-
class Core::Settings

  # Переустановка/обнуление настроек сайта
  #
  # @return [Boolean] true в случае успешной переустановки прав доступа
  #
  def self.rebuild

  ActiveRecord::Base.connection.execute('TRUNCATE TABLE settings')
  settings = []
  settings << { name: 'side_bar_banner',      content: '1' }
  settings << { name: 'match_live',           content: '0' }
  settings << { name: 'side_bar_main_news',   content: '0' }
  settings << { name: 'side_bar_photo_video', content: '0' }
  settings << { name: 'side_bar_socials',     content: '1' }
  settings << { name: 'side_bar_columnists',  content: '0' }
  settings << { name: 'side_bar_tags',        content: '1' }
  settings << { name: 'side_bar_broadcast',   content: '0' }
  settings << { name: 'match_id',             content: '8' }
  Setting.create(settings)

  end

end