# encoding: utf-8
# == Schema Information
#
# Table name: twitter_persons        # Твиты данных песрон подкачиваются на сайт.
#
#  id              :integer          not null, primary key
#  name            :string           not null               # имя персоны в твиттере
#  link            :string                                  # ссылка на твиттер персоны
#  created_at      :datetime
#  updated_at:     :datetime
#

# Твиты данных песрон подкачиваются на сайт. (поиск по name в твиттере)
class TwitterPerson < ActiveRecord::Base
  validates_with Validators::Resource, hosts: %w(twitter.com)

  attr_accessible :name, :link
end