# == Schema Information
#
# Table name: events # События в рамках текстовой трансляции
#
#  id            :integer          not null, primary key
#  type          :string(255)                            # Вспомогательное поле для реализации Single-Table Inheritance
#  player_id     :integer                                # Внешний ключ для связи с игроком
#  team_id       :integer                                # Внешний ключ для связи с игроком
#  match_id      :integer                                # Внешний ключ для связи с матчем
#  player_in_id  :integer                                # Внешний ключ для игрока который выходит на поле (замена)
#  player_out_id :integer
#  card_type     :integer                                # 1 - желтая карточка, 2 - красная карточка
#  timestamp     :decimal(5, 2)                          # Время события в минутах, например, 35, 42, 87 минуты матча
#  count_home    :integer                                # Счет принимающей команды
#  count_guest   :integer                                # Счет гостевой команды
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ActiveRecord::Base
  attr_accessible \
    :type,
    :timestamp,
    :team,
    :team_id,
    :match,
    :match_id

  has_one :broadcast_messages

  belongs_to :team
  belongs_to :match

  scope :goals,       -> { where(type: Event::Goal.name) }
  scope :cards,       -> { where(type: Event::Card.name) }
  scope :replacement, -> { where(type: Event::Replacement.name) }

  def to_hash
    {
      id:        id,
      team:      team.to_hash(:event),
      alt:       timestamp,
      timestamp: timestamp
    }
  end
end
