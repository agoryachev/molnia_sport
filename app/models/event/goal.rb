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

class Event::Goal < Event
  attr_accessible :player_id, :player, :count_home, :count_guest

  belongs_to :player, class_name: 'Person', foreign_key: :player_id

  before_validation :set_score, :check_auto

  after_save :update_match, on: :create

  validates :count_home, :count_guest, presence: true, numericality: true
  validates :player_id, presence: true

  def set_score
    self.count_home  = match.count_home  || 0
    self.count_guest = match.count_guest || 0
    if match.team_home_id == team_id
      self.count_home += 1
    else
      self.count_guest += 1
    end
  end

  def check_auto
    self.auto = team.persons.exists? player_id
  end

  def update_match
    match.count_guest = self.count_guest
    match.count_home  = self.count_home
    match.save validate: false
  end

  def image_url
    ActionController::Base.helpers.image_path('matches/ball.png')
  end

  def to_hash
    super.merge \
      count_home:  count_home,
      count_guest: count_guest,
      image:       image_url,
      alt:         player.full_name,
      player:      player.to_hash(:event),
      auto:        auto,
      goal:        true
  end
end
