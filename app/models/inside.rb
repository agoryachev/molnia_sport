# encoding: utf-8
# == Schema Information
#
# Table name: insides # Инсайд-новости (трансферные слухи)
#
#  id               :integer          not null, primary key
#  content          :text             default(""), not null    # Содержимое новости
#  source           :string(255)      default("")              # Источник
#  person_id        :integer                                   # Внешний ключ для связи с персоной, к которой относятся слухи
#  inside_status_id :integer                                   # Внешний ключ для связи со статусом новости (слухи, переговоры, официально и т.п.)
#  is_published     :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted       :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  published_at     :datetime                                  # Дата и время публикации новости
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# Трансферные слухи
class Inside < ActiveRecord::Base

  attr_accessible \
    :content,
    :source,
    :inside_status_id,
    :person_id,
    :is_published,
    :is_deleted,
    :published_at

  belongs_to :person
  belongs_to :inside_status

  validates :content, :published_at, presence: true

  scope :not_deleted,  ->(){ where(is_deleted: 0) }
  scope :is_published, ->(){where(is_published: 1, is_deleted: 0)}

end
