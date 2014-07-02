# -*- coding: utf-8 -*-

# Улучшенный генератор ключей
#
class Statistics::Keys < Statistics::Base

  # Возвращает имя ключа Redis, в котором хранятся хиты и хосты для выбранной новости
  #
  # @param [String] date - дата, по которой строится ключ в формате YYYY.mm.dd (по-умолчанию: сегодня)
  # @return [String]
  #
  def self.get_key(pub_type=nil, id=nil, date = nil)

    base = Statistics::Base.new

    key      = base.get_key_prefix
    entities = base.get_entities
    
    if pub_type.present? && entities.include?(pub_type)
      key += ":#{pub_type}"
      if id.present?
        key += ":#{id}"
        if date.present?
          key += ":#{date}"
        end
      end
    end
    key
  end


end