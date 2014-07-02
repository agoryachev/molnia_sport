# -*- coding: utf-8 -*-
class ClearCacheJob < Struct.new(:model)
  def perform
    @logger = Logger.new('log/jobs.log')
    begin
      Cache::RedisStore.expire_cache_for(model)
    rescue => e 
      @logger.error "[ClearCacheJob] #{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR: #{e.message}" 
    end
  end
end