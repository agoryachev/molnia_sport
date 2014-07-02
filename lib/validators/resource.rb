module Validators
  class Resource < ActiveModel::Validator
    VALID_STATUS_CODES = %w[200].freeze

    # Валидация передаваемого объекта (ссылка или response)
    def validate(object)
      @object = object
      @uri = URI(object.link)
      unless valid_link? or valid_response?
        @object.errors.add :link, 'Неверная ссылка'
      end
    rescue
      @object.errors.add :link, 'Неверная ссылка'
    end

    private

    # Проверка валидности response (через код ответа)
    def valid_response?
      VALID_STATUS_CODES.include? get_response_code
    rescue
      false
    end

    # Проверка кода response (сравнение с ожидаемым)
    def get_response_code
      @uri.open(allow_redirections: :safe) do |response|
        if response.respond_to? :code
          response.code
        elsif File.file? response
          '200'
        end
      end
    end

    # Проверка ссылки на валидность (три части - хост, путь и параметры)
    def valid_link?
      valid_host? and valid_query? and valid_path?
    end

    # Проверка валидности хоста в валидируемой ссылке
    def valid_host?
      @options
        .fetch(:hosts)
        .map { |host| host.start_with?('www') ? [host[4..-1], host] : [ "www.#{host}", host] }
        .flatten
        .any? { |host| @uri.host.eql? host }
    end

    # Проверка валидности параметров url в валидируемой ссылке
    def valid_query?
      if @uri.query.nil?
        true
      else
        @uri.query.match @options.fetch(:query, /.+/)
      end
    end

    # Проверка валидности пути в валидируемой ссылке
    def valid_path?
      @uri.path.match @options.fetch(:path, /.+/)
    end
  end
end