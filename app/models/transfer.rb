# encoding: utf-8
# == Schema Information
#
# Table name: transfers # Трансферы - переходы игроков
#
#  id                  :integer          not null, primary key
#  person_id           :integer          not null                 # Внешний ключ для связи с персоной
#  team_from_id        :integer                                   # Внешний ключ для связи с командой, которую игрок покидает
#  team_to_id          :integer                                   # Внешний ключ для связи с командой, в которую игрок приходит
#  content             :text                                      # Описание трансфера
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  state               :integer          default(0), not null     # Статус трансфера: 0 - начавшийся трансфер, 1 - завершившийся трансфер
#  start_at            :datetime                                  # Дата и время начала трансфера
#  finish_at           :datetime                                  # Дата и время завершения трансфера
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Трансферы игроков
class Transfer < ActiveRecord::Base

  attr_accessible  :person_id, :team_from_id, :team_to_id,
                   :state,                # Статус трансфера: 0 - начавшийся трансфер, 1 - завершившийся трансфер
                   :start_at,             # Дата и время начала трансфера
                   :finish_at,            # Дата и время завершения трансфера
                   :is_published,
                   :is_comments_enabled,
                   :content

  belongs_to :person
  belongs_to :team_from, class_name: "Team", foreign_key: :team_from_id
  belongs_to :team_to, class_name: "Team", foreign_key: :team_to_id

  validates :person, :start_at, :finish_at, :team_from, :team_to, presence: true

  # Scopes
  # ================================================================
  scope :not_deleted,  ->(){ where('is_deleted = 0') }
  scope :is_published, ->(){ where("is_published = 1 AND is_deleted = 0") }

end
