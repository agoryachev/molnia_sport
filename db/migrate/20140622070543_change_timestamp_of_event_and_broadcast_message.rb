# encoding: utf-8
class ChangeTimestampOfEventAndBroadcastMessage < ActiveRecord::Migration
  def up
    change_column :events,             :timestamp, :integer, after: :type
    change_column :broadcast_messages, :timestamp, :integer, after: :content
  end

  def down
    change_column :events,             :timestamp, :decimal, precision: 5, scale: 2
    change_column :broadcast_messages, :timestamp, :decimal, precision: 5, scale: 2
  end
end
