require 'redis'

REDIS_CONF = YAML.load_file(Rails.root.join('config','redis.yml'))['default']
$redis = Redis.new(host: REDIS_CONF['url'], port: REDIS_CONF['port'])