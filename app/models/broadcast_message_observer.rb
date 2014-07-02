class BroadcastMessageObserver < ActiveRecord::Observer
  def self.redis
    @redis ||= Redis.new
  end

  # Если понадобиться уведомления только ПОСЛЕ успешного сохранения в БД,
  # то следует расскоментировать метод ниже и класс Message и закомментировать остальные
  # def after_commit(message)
  #   Message.new(message).deliver!
  # end

  def after_create(message)
    publish 'create', message
  end

  def after_update(message)
    publish 'update', message
  end

  def after_destroy(message)
    publish 'delete', message, { id: message.id, action: 'delete' }.to_json
  end

  private

  def publish(channel, message, json = message.to_json(:api, { action: channel }))
    self.class.redis.publish "broadcast_message.#{channel}.#{message.match_id}", json
  end

  # class Message
  #   def self.redis
  #     @redis ||= Redis.new
  #   end

  #   def self.crud_identity
  #     @identity_hash ||= Hash.new do |hash, key|
  #       hash[key] = -> (message) { message.__send__ :transaction_include_action?, key }
  #     end
  #   end

  #   def initialize(message)
  #     @message = message
  #   end

  #   def deliver!
  #     case @message
  #     when created? then publish 'create'
  #     when updated? then publish 'update'
  #     when destroyed?
  #       publish 'delete', { id: @message.id, action: 'delete' }.to_json
  #     end
  #   end

  #   private

  #   { create: :created?, update: :updated?, destroy: :destroyed? }.each do |key, method|
  #     define_method(method) { self.class.crud_identity[key] }
  #   end

  #   def publish(channel, json = @message.to_json(:api, { action: channel }))
  #     self.class.redis.publish "broadcast_message.#{channel}.#{@message.match_id}", json
  #   end
  # end
end