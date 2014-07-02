# encoding: utf-8
# == Schema Information
#
# Table name: matches # Матчи
#
#  id                  :integer          not null, primary key
#  team_home_id        :integer                                   # Внешний ключ для связи с принимающей командой
#  team_guest_id       :integer                                   # Внешний ключ для связи с гостевой командой
#  leagues_group_id    :integer                                   # Связь с таблицей группы
#  title               :string(255)                               # Название матча
#  content             :text                                      # Описание матча
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  count_home          :integer                                   # Очки принимащей команды (сколько забили голов/шайб гостевой команде)
#  count_guest         :integer                                   # Очки гостевой команды (сколько забили голов/шайб принимающей команде)
#  start_at            :datetime                                  # Дата и время начала матча
#  finish_at           :datetime                                  # Дата и время завершения матча
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryGirl.define do
  factory :match do

    team_home_id          1
    team_guest_id         1
    leagues_group_id      1
    title                 Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    is_published          1
    is_deleted            0
    is_comments_enabled   1
    count_home            0
    count_guest           0
    date_at               Date.today
    start_at              Time.now
    finish_at             Time.now

  end
end