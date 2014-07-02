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

class Event::Replacement < Event
  attr_accessible :player_in_id, :player_out_id

  belongs_to :player_out, class_name: 'Person', foreign_key: :player_out_id
  belongs_to :player_in,  class_name: 'Person', foreign_key: :player_in_id

  before_validation :set_team

  validates :player_in_id, :player_out_id, :team_id, presence: true

  def set_team
    _team_id_in  = match.teams.detect { |team| team.persons.exists? player_in.id }.id
    _team_id_out = match.teams.detect { |team| team.persons.exists? player_out.id }.id
    if _team_id_out == _team_id_in
      self.team_id = _team_id_in
    else
      errors.add[:team_id] << 'Игроки разных команд!'
    end
  end

  def image_url
    ActionController::Base.helpers.image_path('matches/replacement.png')
  end

  def to_hash
    super.merge \
      player_in:   player_in.to_hash(:event),
      player_out:  player_out.to_hash(:event),
      alt:         "#{player_out.full_name} => #{player_in.full_name}",
      image:       image_url,
      replacement: true
  end
end
