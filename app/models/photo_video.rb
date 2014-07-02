# encoding: utf-8
# == Schema Information
#
# Table name: feeds # Лента со всеми материалами: Новости, Галлереи и Видео
#
#  id            :integer          not null, primary key
#  feedable_id   :integer
#  feedable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PhotoVideo < ActiveRecord::Base
  self.table_name = 'feeds'
  attr_accessible :feedable_id, :feedable_type

  # Relations
  # ================================================================
  belongs_to :feedable, polymorphic: true

  # Validates
# ================================================================
  validates_uniqueness_of :feedable_id, scope: :feedable_type

  # Scopes
# ================================================================
  scope :limit_feeds, ->(count = 5){ limit(count) }

  # Methods
# ================================================================

  class << self
    def get_feeds
      PhotoVideo.joins('LEFT JOIN galleries AS g ON feedable_id = g.id AND feedable_type = "Gallery"')
                .joins('LEFT JOIN videos AS v ON feedable_id = v.id AND feedable_type = "Video"')
                .where('COALESCE(g.is_deleted, v.is_deleted) = 0')
                .where('COALESCE(g.is_published, v.is_published) = 1')
                .where("COALESCE(g.published_at, v.published_at) <= '#{Time.now.utc.to_s(:db)}'")
    end

    # Загружает 5 последних публикаций по типам: gallery, video
    #
    # @return [Array] - массив публикаций
    #
    def last_5_for_main_news _
      get_feeds.order("COALESCE(g.published_at, v.published_at) DESC").limit_feeds
    end

    # Загружает 5 самых обсуждаемых публикаций по типам: gallery, video
    #
    # @return [Array] - массив публикаций
    #
    def discussed_5_for_main_news _
      get_feeds.order("COALESCE(g.comments_count, v.comments_count) DESC").limit_feeds
    end

    # Загружает 5 самых посещаемых публикаций по типам: gallery, video
    #
    # @return [Array] - массив публикаций
    #
    def popular_5_for_main_news _
      order = Statistics::Top.new.get_top_by_types(['galleries', 'videos']).inject([]) do |result, publication|
        result << publication.join(':')
        result
      end
      order = "FIELD(CONCAT(feedable_type,':',feedable_id),'#{order.join('\',\'')}')"
      get_feeds.order("IF(#{order}, #{order}, 99999), COALESCE(g.published_at, v.published_at) DESC").limit_feeds
    end

  end

end
