# encoding: utf-8
# == Schema Information
#
# Table name: broadcast_messages # Сообщение в рамках текстовой трансляции
#
#  id         :integer          not null, primary key
#  match_id   :integer          not null              # Внешний ключ для связи с матчем
#  event_id   :integer                                # Внешний ключ для связи с событием
#  content    :string(255)      default("")           # Содержимое сообщения
#  timestamp  :decimal(5, 2)                          # Время события от начала матча, целая чать - минуты, дробная - секунды
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BroadcastMessage < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  attr_accessible \
    :content,
    :timestamp

  belongs_to :event
  belongs_to :match

  validates :content, presence: true

  before_create :clean_content!

  # Если понадобится сохранение твитов и фотографий из инстаграмма в нашу БД
  # то следует раскомментировать код ниже

  # before_create :check_content!
  # after_create  :append_attachments

  # def check_content!
  #   instagram, twitter, empty_string = /instagram/, /twitter/, ''.freeze
  #   @attachments = content.gsub!(/http[s]{0,1}:\/\/[^\s]+/).each_with_object [] do |link, attachments|
  #     wrapped_link = "<a href='#{link}'></a>"
  #     attachment =  case link
  #                   when instagram then InstagramRecord.new link: link
  #                   when twitter   then Tweet.new link: link
  #                   else wrapped_link
  #                   end
  #     if attachment.valid?
  #       attachments << attachment and empty_string
  #     else
  #       wrapped_link
  #     end rescue wrapped_link
  #   end
  # end

  # def append_attachments
  #   time = Time.now
  #   @attachments.each do |attachment|
  #     attachment.owner = self
  #     attachment.published_at = time
  #     attachment.save
  #   end
  # end

  def clean_content!
    self.content = sanitize content
  end

  def to_json(target = nil, custom = {})
    return super if target.nil?
    case target
    when :api then to_hash.merge(custom).to_json
    else super
    end
  end

  def to_hash
    {
      id: id,
      message: {
        id:   id,
        text: content,
        time: timestamp
      },
      event: event.try(:to_hash)
    }
  end
end
