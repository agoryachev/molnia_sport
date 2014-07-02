# encoding: utf-8
class AddTimestampToBroadcastMessages < ActiveRecord::Migration
  def change
    add_column :broadcast_messages, :timestamp, :decimal, precision: 5, scale: 2, after: :content, comment: 'Время события от начала матча, целая чать - минуты, дробная - секунды'
    change_column :events, :timestamp, :decimal, precision: 5, scale: 2
    set_column_comment :events, :name, 'Время события от начала матча, целая чать - минуты, дробная - секунды'
  end
end