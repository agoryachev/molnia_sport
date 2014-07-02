require 'json'
require 'redis'
require 'sinatra'
require 'sinatra-websocket'

class TextBroadcasts < Sinatra::Base
  connections = Hash.new { |hash, match_id| hash[match_id] = [] }
  redis = Redis.new timeout: 0

  # before do
  #   headers 'Access-Control-Allow-Origin' => '*',
  #           'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
  # end

  Thread.new do
    redis.psubscribe 'broadcast_message.*' do |on|
      on.pmessage do |_, channel, message|
        connections[channel.split('.').last.to_i].each { |ws| ws.send message }
        # connections[message.match_id].each { |out| out << "data:#{message.to_json}\n" << "id:#{message.id}\n\n" }
      end
    end
  end

  get '/connect/:match_id' do |match_id|
    if request.websocket?
      request.websocket do |ws|
        ws.onopen  { connections[match_id.to_i] << ws }
        ws.onclose { connections[match_id.to_i].delete(ws) }
      end
    else
      204
    end
  end

  # get '/connect/:match_id', provides: 'text/event-stream' do |match_id|
  #   if Match.where(id: match_id).first.try(:finish_at) < Time.now
  #     stream :keep_open do |out|
  #       connections[match_id.to_i] << out
  #       out.callback { connections.delete(out) }
  #     end
  #   else
  #     204
  #   end
  # end
end