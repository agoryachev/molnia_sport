require ::File.expand_path('../lib/text_broadcasts',  __FILE__)
require ::File.expand_path('../config/environment',  __FILE__)

map '/api/broadcasts' do
  run TextBroadcasts
end
