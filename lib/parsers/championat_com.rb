# encoding: utf-8
module Parsers

  # Парсер сайта championat.com
  #
  class ChampionatCom
    include Parsers::Creator
    include Parsers::FileLoader
    include Parsers::Extractor

    def initialize
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `matches`')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `leagues`')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `leagues_groups`')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `persons`')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `years`')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE `teams_persons`')
      @base_url = 'http://www.championat.com'
      @load_main_image = false
    end

    # Загрузка страницы
    #
    # @param [String] url - загружаемый URL
    # @return [Object] - структура страницы в формате Nokogiri
    #
    def load_html(url)
      url = File.join(@base_url, url) unless url[0..6] == 'http://'
      Nokogiri::HTML(open(url)) do |config|
        config.noblanks
      end
    end
  end

end
