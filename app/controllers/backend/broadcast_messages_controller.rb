# encoding: utf-8
class Backend::BroadcastMessagesController < ContentController

  # POST /backend/matches/:match_id/broadcast_messages(.:format)
  def create
    match = Match.find params[:match_id]
    message = match.broadcast_messages.build content: message_params[:content], timestamp: message_params[:timestamp]
    event_type = message_params[:event_type]
    event_params = message_params[event_type]
    unless event_params.nil?
      message.event = Event.const_get(event_type.classify).create event_params.merge(match_id: match.id, timestamp: message_params[:timestamp])
    end
    message.save
    render json: { result: message.to_hash, success: message.persisted? }
  end

  def destroy
    message = BroadcastMessage.find(params[:id]).destroy
    Event.find(message.event_id).destroy if message.event_id.present?
    render json: { result: message, success: !message.persisted? }
  end

  private

  def message_params
    params[:broadcast_message]
  end
end