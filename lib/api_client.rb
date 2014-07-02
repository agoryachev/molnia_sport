# encoding: utf-8
module APIClient
  def self.extended(base)
    class << base

      # DSL-метод для создания instance API клиента для социалок (твиттер и инстаграм)
      # key - название API клиента (ключ ФAPI клиента в oauth)
      # class_object - класс API клиента, если он отличается он названия
      def api_class(key, class_object = key.to_s.camelize.constantize)
        @mutex  ||= Mutex.new
        @client ||= class_object::Client.new OAUTH[key.to_s].symbolize_keys
      end

      # DSL-метод для вызова методов API клиента
      # method_name - имя метода строкой
      # params - опции для метода
      def api_request(method_name, *params)
        @mutex.synchronize { @client.__send__ method_name, *params }
      end
    end
  end
end