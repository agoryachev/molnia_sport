# encoding: utf-8
# == Schema Information
#
# Table name: teams_persons # Связующая таблица команд (teams) с персоналиями (persons)
#
#  id        :integer          not null, primary key
#  team_id   :integer          not null              # Внешний ключ для связи с командой
#  person_id :integer          not null              # Внешний ключ для связи с персоной
#

FactoryGirl.define do
  factory :teams_person do

    team                { FactoryGirl.create(:team) }
    person              { FactoryGirl.create(:person) }

  end
end