# -*- coding: utf-8 -*-

# Извлечение хитов и хостов
#
class Statistics::Visits < Statistics::Base

  def initialize
    super
  end

  # Возвращает хиты за все время для материала
  #
  # @param id [Integer] идентификатор материала (Post, Gallery, Video)
  # @param pub_type [String] тип публикации (posts galleries videos или Post, Gallery, Video)
  # @return [Integer] количество хитов (просмотров)
  #
  def self.hits id, pub_type = 'posts', date=nil
    pub_type = pub_type.pluralize.downcase if pub_type.present?
    redis_key = Statistics::Keys::get_key(pub_type, id, date)
    $redis.hget(redis_key, 'hits')
  end

  # Возвращает хостов за все время для материала
  #
  # @param id [Integer] идентификатор материала (Post, Gallery, Video)
  # @param pub_type [String] тип публикации (posts galleries videos или Post, Gallery, Video)
  # @return [Integer] количество хостов (посетителей)
  #
  def self.hosts id, pub_type = 'posts', date=nil
    pub_type = pub_type.pluralize.downcase if pub_type.present?
    redis_key = Statistics::Keys::get_key(pub_type, id, date)
    $redis.hget(redis_key, 'hosts')
  end

end