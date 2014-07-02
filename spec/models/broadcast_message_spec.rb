# == Schema Information
#
# Table name: broadcast_messages # Сообщение в рамках текстовой трансляции
#
#  id         :integer          not null, primary key
#  match_id   :integer          not null              # Внешний ключ для связи с матчем
#  event_id   :integer                                # Внешний ключ для связи с событием
#  content    :string(255)      default("")           # Содержимое сообщения
#  timestamp  :decimal(5, 2)                          # Время события от начала матча, целая чать - минуты, дробная - секунды
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe BroadcastMessage do
  pending "add some examples to (or delete) #{__FILE__}"
end
