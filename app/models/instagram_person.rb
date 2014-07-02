# encoding: utf-8
# == Schema Information
#
# Table name: instagram_persons      # Фото в инстаграм данных песрон подкачиваются на сайт.
#
#  id              :integer          not null, primary key
#  insta_id        :string           not null               # id персоны в инстаграм (как идентификатор)
#  name            :string           not null               # имя персоны в инстаграм
#  link            :string                                  # ссылка на инстаграм персоны
#  created_at      :datetime
#  updated_at:     :datetime
#

# Фото в инстаграм данных песрон подкачиваются на сайт (поиск в инстаграме по id)
class InstagramPerson < ActiveRecord::Base
  validates_with Validators::Resource, hosts: %w(instagram.com)

  attr_accessible :insta_id, :name, :link
end