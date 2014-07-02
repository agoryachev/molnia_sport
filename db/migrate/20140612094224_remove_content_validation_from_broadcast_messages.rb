# encoding: utf-8
class RemoveContentValidationFromBroadcastMessages < ActiveRecord::Migration
  def change
    change_column :broadcast_messages, :content, :string, null: true
  end
end
