# encoding: utf-8
# == Schema Information

# Table name: tactical_schemes # Тактические построения команд
#  id                  :integer     not null, primary key
#  forward,            :integer     default(0)      # Количество нападающих
#  halfback,           :integer     default(0)      # Количество полузащитников
#  forward_halfback,   :integer     default(0)      # Количество атакующих полузащитников
#  defender_halfback,  :integer     default(0)      # Количество опорных полузащитников
#  defender,           :integer     default(0)      # Количество защитников
#  in_detail,          :boolean     default(FALSE)  # Подробная расстановка (разбиваются полузащитники)
#  created_at          :datetime
#  updated_at          :datetime

# Тактические построения команд
class TacticalScheme < ActiveRecord::Base
  attr_accessible \
    :forward,
    :halfback,
    :forward_halfback,
    :defender_halfback,
    :defender,
    :in_detail

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published AND NOT is_deleted AND published_at <= '#{Time.now.utc.to_s(:db)}'") }

  def description
    description = in_detail? ? [defender, defender_halfback, forward_halfback, forward].join('-') : [defender, halfback, forward].join('-')
    description
  end
end