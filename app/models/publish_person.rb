# encoding: utf-8
# == Schema Information
#
# Table name: publish_persons
#
#  id               :integer          not null, primary key
#  publishable_type :string(255)                            # Полиморфная связь с публикацией
#  publishable_id   :integer                                # Полиморфная связь с публикацией
#  person_id        :integer                                # Связь с игроком
#

class PublishPerson < ActiveRecord::Base
  attr_accessible :person_id, :publishable_id, :publishable_type
  belongs_to :person
  belongs_to :publishable, polymorphic: true
end
