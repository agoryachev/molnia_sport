# -*- coding: utf-8 -*-

# Агрегация хитов и хостов в Redis
#
class Statistics::Aggregate < Statistics::Base

  ##########################################################################################################################
  # Пример использования сагрегированной статистики:
  #
  # stat_base = Statstics::Base.new
  # date = '2014.03.12'
  # $redis.hgetall(stat_base.get_hosts_key).sort_by{|k,v|v}.reverse[0..19]               # топ 20 по хостам за все время
  # $redis.hgetall(stat_base.get_hits_key).sort_by{|k,v|v}.reverse[0..19]                # топ 20 по хитам за все время
  # $redis.hgetall(stat_base.get_hosts_by_date_key(date)).sort_by{|k,v|v}.reverse[0..19] # топ 20 по хостам за 2014.03.12
  # $redis.hgetall(stat_base.get_hits_by_date_key(date)).sort_by{|k,v|v}.reverse[0..19]  # топ 20 по хитам за 2014.03.12
  ##########################################################################################################################

  def initialize
    super
    @date = (Date.today-1).strftime("%Y.%m.%d")
    # Работаем только со следующими сущностями
    @entities = %w(posts galleries videos)
    run
  end

  # Агрегация статистики в Redis
  #
  def run
    # определяем значения ключей один раз до циклов
    hits_by_date_key = get_hits_by_date_key(@date)
    hosts_by_date_key = get_hosts_by_date_key(@date)
    hits_key = get_hits_key
    hosts_key = get_hosts_key        
    # Для каждой сущности при наличии id в буфере находим
    # соответствующий хеш и сохраняем его данные в определенные выше ключи
    # После успешного сохранения удаляем и буфер и хеш.
    @entities.each do |entity|
      @post_type = entity
      posts_buffer_key = get_posts_buffer_key(@date)
      if $redis.exists(posts_buffer_key)
        $redis.smembers(posts_buffer_key).each do |id|
          @post_id = id
          post_by_date_key = get_post_by_date_key(@date)
          stats = $redis.hgetall(post_by_date_key)
          $redis.hset(hits_by_date_key, "#{@post_type}:#{@post_id}", stats['hits']) unless stats['hits'].nil?
          $redis.hset(hosts_by_date_key, "#{@post_type}:#{@post_id}", stats['hosts']) unless stats['hosts'].nil?
          stats = $redis.hgetall(get_post_key)
          $redis.hset(hits_key, "#{@post_type}:#{@post_id}", stats['hits']) unless stats['hits'].nil?
          $redis.hset(hosts_key, "#{@post_type}:#{@post_id}", stats['hosts']) unless stats['hosts'].nil?
          # удаляем вчерашнюю статистику по текущей публикации
          $redis.del(post_by_date_key)
        end
        # Удаляем вчерашний буфер публикаций
        $redis.del(posts_buffer_key)
      end
    end
  end
end
