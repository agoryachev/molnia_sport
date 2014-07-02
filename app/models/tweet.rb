# encoding: utf-8
# == Schema Information
#
# Table name: tweets
#
#  id           :integer          not null, primary key
#  data         :text                                      # Данные о твите в json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_published :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  link         :string(255)      default(""), not null    # ссылка на твит
#  is_deleted   :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  published_at :datetime         not null                 # Дата и время публикации
#

class Tweet < ActiveRecord::Base
  validates_with Validators::Resource, hosts: %w(twitter.com), path: /\A\/\w+\/status\/\d+/

  attr_accessible :data

  extend APIClient
  api_class :twitter, Twitter::REST # создание клиента, связь с api_class

  before_save :build_data

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published AND NOT is_deleted AND published_at <= '#{Time.now.utc.to_s(:db)}'") }
  scope :not_empty,    ->(){ where('data is not null')}


  # подготвавливаем данные пришедшие из твиттера для сохранения в БД
  # tweet - структура инфы о твите приходящая из твиттера
  def build_data
    self.data = self.class.api_request('status', link.split('/').last).to_h.tap do |hash|
      hash.merge! hash.delete(:entities)
      hash[:hashtags].map! { |tag| tag[:text] }
      hash.merge! hash[:media].first.slice(:media_url_https) if hash.key? :media
      hash.merge! 'text' => generate_text(hash)
    end.to_json if link_changed?
  end

  # форматировнаие текста твиттера (вставка ссылок и тегов)
  def generate_text(tweet)
    hash = {}
    (tweet.fetch(:media, []) + tweet.fetch(:urls, [])).each_with_object(hash) do |url, result|
      result[url[:url]] = "<a title='#{url[:expanded_url]}' href='#{url[:url]}'>#{url[:display_url]}</a>"
    end
    tweet.fetch(:hashtags,[]).each_with_object(hash) do |tag, result|
      result["##{tag}"] = "<a href='https://twitter.com/search?q=#{tag}&src=hash'>##{tag}</a>"
    end
    tweet.fetch(:user_mentions, []).each_with_object(hash) do |name, result|
      result["@#{name}"] = "<a href='https://twitter.com/#{name}'>@#{name}</a>"
    end
    tweet[:text].gsub /(#|@|https?:\/\/[^\/]+\/)[^\s,\.$]+/, hash
  end
end
