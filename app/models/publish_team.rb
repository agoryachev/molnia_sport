# encoding: utf-8
# == Schema Information
#
# Table name: publish_teams
#
#  id               :integer          not null, primary key
#  publishable_type :string(255)                            # Полиморфная связь с публикацией
#  publishable_id   :integer                                # Полиморфная связь с публикацией
#  team_id          :integer                                # Связь с командой
#

class PublishTeam < ActiveRecord::Base
  attr_accessible :person_id, :publishable_id, :publishable_type
  belongs_to :team
  belongs_to :publishable, polymorphic: true
end
