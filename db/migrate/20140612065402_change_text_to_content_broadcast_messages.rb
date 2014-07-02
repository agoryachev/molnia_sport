# encoding: utf-8
class ChangeTextToContentBroadcastMessages < ActiveRecord::Migration
  def change
    set_table_comment :broadcast_messages, 'Сообщение в рамках текстовой трансляции'
    rename_column :broadcast_messages, :text, :content
    set_column_comment :broadcast_messages, :content, 'Содержимое сообщения'
    set_column_comment :broadcast_messages, :match_id, 'Внешний ключ для связи с матчем'
    set_column_comment :broadcast_messages, :event_id, 'Внешний ключ для связи с событием'

    change_column :events, :count_home, :integer, null: false, after: :timestamp
    change_column :events, :count_guest, :integer, null: false, after: :count_home

    set_table_comment :events, 'События в рамках текстовой трансляции'
    set_column_comment :events, :name, 'Название события'
    set_column_comment :events, :type, 'Вспомогательное поле для реализации Single-Table Inheritance'
    set_column_comment :events, :player_id, 'Внешний ключ для связи с игроком'
    set_column_comment :events, :team_id, 'Внешний ключ для связи с игроком'
    set_column_comment :events, :match_id, 'Внешний ключ для связи с матчем'
    set_column_comment :events, :player_in_id, 'Внешний ключ для игрока который выходит на поле (замена)'
    set_column_comment :events, :player_out_id, 'Внешний ключ для игрока который покидает поле (замена)'
    set_column_comment :events, :count_home, 'Счет принимающей команды'
    set_column_comment :events, :count_guest, 'Счет гостевой команды'
    set_column_comment :events, :card_type, '1 - желтая карточка, 2 - красная карточка'
    set_column_comment :events, :timestamp, 'Время события в минутах, например, 35, 42, 87 минуты матча'
  end
end