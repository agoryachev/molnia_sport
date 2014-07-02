# encoding: utf-8
class ChangeContentOfBroadcastMessage < ActiveRecord::Migration
  def change
    change_column :broadcast_messages, :content, :text, null: true
  end
end
