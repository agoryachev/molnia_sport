# encoding: utf-8
# == Schema Information
#
# Table name: instagram_records
#
#  id           :integer          not null, primary key
#  data         :text                                      # Данные о твите в json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_published :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted   :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  link         :string(255)      default(""), not null    # ссылка на фото
#  published_at :datetime         not null                 # Дата и время публикации
#

class InstagramRecord < ActiveRecord::Base
  validates_with Validators::Resource, hosts: %w(instagram.com), path: /\A\/p\/[^\/]+\/*\z/

  attr_accessible :data

  extend APIClient
  api_class :instagram # создание клиента, связь с api_class

  before_save :build_data

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published AND NOT is_deleted AND published_at <= '#{Time.now.utc.to_s(:db)}'") }
  scope :not_empty,    ->(){ where('data is not null')}

  # подготвавливаем данные пришедшие из инстаграма для сохранения в БД
  # instagram - структура инфы об image приходящая из инстаграма
  def build_data
    if link_changed?
      id = JSON.parse(Net::HTTP.get(URI("http://api.instagram.com/oembed?url=#{link}")))['media_id']
      response_data = self.class.api_request(:media_item, id)
      i_data = response_data.caption.from.to_h
      i_data.merge! \
        'caption'    => response_data.caption.text,
        'likes'      => response_data.likes['count'],
        'caption_id' => response_data.caption.id,
        'url'        => response_data.images.standard_resolution.url,
        'link'       => response_data.link,
        'created_at' => response_data.created_time.to_i*1000
      self.data = i_data.to_json
    end
  end
end
