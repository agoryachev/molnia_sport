# == Schema Information
#
# Table name: events # События в рамках текстовой трансляции
#
#  id            :integer          not null, primary key
#  name          :string(255)                            # Время события от начала матча, целая чать - минуты, дробная - секунды
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

class Event::Card < Event
  CARD_COLORS = { 1 => 'yellow', 2 => 'red' }

  attr_accessible :player_id, :card_type

  belongs_to :player, class_name: 'Person', foreign_key: :player_id

  before_validation :set_team

  validates :player_id, :card_type, :team_id, presence: true
  validates :card_type, inclusion: { in: 1..2 }

  def set_team
    self.team_id = match.teams.detect { |team| team.persons.exists? player.id }.id
  end

  def image_url
    ActionController::Base.helpers.image_path("matches/#{CARD_COLORS[card_type]}_card.png")
  end

  def to_hash
    super.merge \
      player:    player.to_hash(:event),
      image:     image_url,
      alt:       player.full_name,
      card_type: CARD_COLORS[card_type],
      card:      true
  end
end
