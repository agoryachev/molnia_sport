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

FactoryGirl.define do
  factory :transfer do

    person              FactoryGirl.build(:person)
    team_from           FactoryGirl.build(:team)
    team_to             FactoryGirl.build(:team)
    content             Faker::Lorem.words(15).join(" ")
    is_published        1
    is_deleted          0
    is_comments_enabled 0
    state               0
    start_at            Time.now
    finish_at           Time.now

  end
end