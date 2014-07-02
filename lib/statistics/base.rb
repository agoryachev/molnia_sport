# -*- coding: utf-8 -*-
class Statistics::Base

  #==================================================================
  # Используемые ключи
  # "sportscup.ru:statistics:posts:110913"             - Основной хеш со счетчиками hits и hosts
  # "sportscup.ru:statistics:posts:110913:2013.04.07"  - то же самое по дате
  # "sportscup.ru:statistics:uids:11913:2013.04.07"    - Буфер уникальных uid посетителей поста за сутки
  # "sportscup.ru:statistics:posts:2013.04.07"         - Буфер уникальных id новостей за сутки
  # "sportscup.ru:statistics:galleries:2013.04.07"     - то же самое для галерей
  # "sportscup.ru:statistics:videos:2013.04.07"        - то же самое для видеороликов
  #==================================================================

  def initialize
    # Храним ключи с префиксом проекта
    @key_prefix = 'sportscup.ru:statistics'
    # Работаем только со следующими сущностями
    @entities = %w(posts galleries videos matches)
    # по умолчанию, ключи с датой формируются на текущий день
    @today = Date.today.strftime('%Y.%m.%d')
    # эти переменные должны быть переопределены в помоках перед запросом ключей
    @post_type = @post_id = ''
  end

  # Возвращает префикс для ключей портала
  #
  # @return [String]
  #
  def get_key_prefix
    @key_prefix
  end

  # Возвращает массив сущностей для которых ведется учет статистики
  #
  # @return [Array]
  #
  def get_entities
    @entities
  end

  # Возвращает имя ключа Redis, в котором хранится список user-agent'ов ботов
  #
  # @return [String]
  #
  def get_bot_key
    "#{@key_prefix}:bots"
  end

  # Возвращает имя ключа Redis, в котором хранятся UID'ы уникальных посетителей за запрошенную дату
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def get_uids_buffer_key(date = nil)
    date ||= @today
    "#{@key_prefix}:uids:#{@post_type}:#{@post_id}:#{date}"
  end

  # Возвращает имя ключа Redis, в котором хранятся ID публикаций просмотренных запрошенную дату
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def get_posts_buffer_key(date = nil)
    date ||= @today
    "#{@key_prefix}:#{@post_type}:#{date}"
  end

  # Возвращает имя ключа Redis, в котором хранятся hits и hosts публикации за все время
  #
  # @return [String]
  #
  def get_post_key
    "#{@key_prefix}:#{@post_type}:#{@post_id}"
  end

  # Возвращает имя ключа Redis, в котором хранятся hits и hosts публикации за запрошенную дату
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def get_post_by_date_key(date = nil)
    date ||= @today
    "#{@key_prefix}:#{@post_type}:#{@post_id}:#{date}"
  end

  # Возвращает имя ключа Redis, в котором хранятся все публикации и их хиты за запрошенную дату
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def get_hits_by_date_key(date = nil)
    date ||= @today
    "#{@key_prefix}:hits:#{date}"
  end

  # Возвращает имя ключа Redis, в котором хранятся все публикации и их хосты за запрошенную дату
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def get_hosts_by_date_key(date = nil)
    date ||= @today
    "#{@key_prefix}:hosts:#{date}"
  end

  # Возвращает имя ключа Redis, в котором хранятся все публикации и их хиты за все время
  #
  # @return [String]
  #
  def get_hits_key
    key = "#{@key_prefix}:hits"
  end

  # Возвращает имя ключа Redis, в котором хранятся все публикации и их хосты за все время
  #
  # @return [String]
  #
  def get_hosts_key
    "#{@key_prefix}:hosts"
  end

end
