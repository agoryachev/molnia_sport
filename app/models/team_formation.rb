# encoding: utf-8
# == Schema Information
#
# Table name: team_formations # таблица по который ищутся составы команд на матчи (по match_id, team_id, person_id)
#
#  id             :integer          not null, primary key
#  team_id        :integer          not null              # id команды
#  match_id       :integer          not null              # id матча
#  person_type    :integer          not null              # тип игрока (амплуа)
#  person_id      :integer          not null              # Внешний ключ для связи с персоной
#  created_at     :datetime
#  updated_at     :datetime

# Составы на матчи (каждая запись указывает на определенного игрока одной из команд)
class TeamFormation < ActiveRecord::Base

  # Ключи для колонки person_type по амплуа игроков
  TEAM_FORMATION_KEYS = {
    forward:            1, # нападающий
    halfback:           2, # полузащитник
    forward_halfback:   3, # атакующий полузащитник
    defender_halfback:  4, # опорный полузащитник
    defender:           5, # защитник
    goalkeeper:         6, # вратарь

    reserve:            10 # запасной
  }

  attr_accessible \
    :team_id,
    :match_id,
    :person_id,
    :person_type

  belongs_to :team
  belongs_to :match
  belongs_to :person

  def type
    TEAM_FORMATION_KEYS.invert[person_type]
  end

  def to_hash(target = nil)
    case target
    when :backbone then person.to_hash(:event, type: type)
    else attributes
    end
  end
end