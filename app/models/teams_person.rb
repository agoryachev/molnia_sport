# encoding: utf-8
# == Schema Information
#
# Table name: teams_persons # Связующая таблица команд (teams) с персоналиями (persons)
#
#  id        :integer          not null, primary key
#  team_id   :integer          not null              # Внешний ключ для связи с командой
#  person_id :integer          not null              # Внешний ключ для связи с персоной
#

# Модель, связывающая команды и игроков
class TeamsPerson < ActiveRecord::Base

  self.table_name = "teams_persons"
  
  belongs_to :person
  belongs_to :team

  # Комбинация :team_id, :person_id должна быть уникальна
  validates_uniqueness_of :team_id, scope: :person_id

end
