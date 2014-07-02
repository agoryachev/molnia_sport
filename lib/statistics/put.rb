# -*- coding: utf-8 -*-

# Запись хитов и хостов в Redis
#
class Statistics::Put < Statistics::Base

  def initialize(request = nil, path_components = [])
    super()
    # request.env хеш, передаваемый в кач-ве аргумента
    @params = request.nil? ? Rack::Request.new(env).env : request.env
    # Разобранный "REQUEST_PATH"
    # [0] => тип поста(posts/galleries/videos)
    # [1] => id
    @post_type = path_components[0][0]
    @post_id   = path_components[0][1]
    # Уникальный md5 хеш (ApplicationController.new.get_adv_uid)
    # существует в течении жизни сессии
    # При отключенных cookies - nil
    @uid = @params['rack.session']['session_id']
    @user_agent = @params['HTTP_USER_AGENT']
    run
  end

  # Сохранение статистики в Redis
  #
  def run
    unless @uid.nil?
      # Засчитываем просмотры
      unless is_bot?
        $redis.hincrby(get_post_key, 'hits', 1)
        $redis.hincrby(get_post_by_date_key, 'hits', 1)
        # Добавляем id просматриваемого поста в буфер
        $redis.sadd(get_posts_buffer_key, @post_id)
      end
      # Засчитываем уникальные
      if uniq_visitor? && !is_bot?
        $redis.hincrby(get_post_key, 'hosts', 1)
        $redis.hincrby(get_post_by_date_key, 'hosts', 1)
      end

      # Буфер uid пользователей поста за сегодняшний день
      $redis.sadd(get_uids_buffer_key, @uid)
      # Буфер должен быть удален по истечении суток
      $redis.expire(get_uids_buffer_key, 24*60*60 - Time.now.seconds_since_midnight.to_i)
    end
  end

private

  # Определяем уникального посетителя - uid не встречается в буфере
  #
  # @return [FalseClass|TrueClass]
  #
  def uniq_visitor?
    !$redis.sismember(get_uids_buffer_key, @uid)
  end

  # Определяем является ли посетитель поисковым ботом по заголовку HTTP_USER_AGENT
  #
  # @return [FalseClass|TrueClass]
  #
  def is_bot?
    !!$redis.sismember(get_bot_key, @user_agent)
  end

end
