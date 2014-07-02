# -*- coding: utf-8 -*-

# Извлечение отсортированных данных
#
class Statistics::Top < Statistics::Base

  def initialize
    super
  end

  # Получение отсортированного списка ID по одному виду публикации за весь период
  #
  # @param [String] pub_type  - тип публикации. Возможны: posts/galleries/videos
  # @param [String] key_type  - параметр, по которому определяем TOP. Возможны: hits/hosts
  # @return [Array] - массив ID публикаций
  #
  def get_top_by_type pub_type = 'posts', key_type = 'hits'
    # определяем ключ из которого будет браться статистика
    redis_key = key_type == 'hits' ? get_hits_key : get_hosts_key
    # извлекаем статистику и фильтруем по типу публикаций
    pubs = $redis.hgetall(redis_key).inject({}) do |result, (key, value)|
      result[key.gsub("#{pub_type}:", '').to_i] = value.to_i if key[0..pub_type.length-1] == pub_type
      result
    end
    # сортируем и отдаем TOP
    pubs.sort_by{|_,v|v}.reverse.inject([]) do |result, value|
      result << value[0]
      result
    end
  end

  # Получение TOP по нескольким видам публикаций за весь период
  #
  # @param [Array] pub_types  - Массив типов публикаций. Возможны: posts/galleries/videos
  # @param [Fixnum] pub_count - Количество возвращаемых публикаций
  # @param [String] key_type  - параметр, по которому определяем TOP. Возможны: hits/hosts
  # @return [Array] - массив ID публикаций
  #
  def get_top_by_types pub_types, pub_count = 5, key_type = 'hits'
    # определяем ключ из которого будет браться статистика
    redis_key = key_type == 'hits' ? get_hits_key : get_hosts_key
    # извлекаем статистику и фильтруем по типу публикаций
    pubs = $redis.hgetall(redis_key).inject({}) do |result, (key, value)|
      result[key] = value.to_i if pub_types.include? key.split(':')[0]
      result
    end
    # сортируем и отдаем TOP
    pubs.sort_by{|_,v|v}.reverse.inject([]) do |result, value|
      type, id = value[0].split(':')
      type = case type
               when 'posts'     then 'Post'
               when 'galleries' then 'Gallery'
               when 'videos'    then 'Video'
             end
      result << [type, id.to_i]
      result
    end[0..pub_count-1]
  end

end
