class CreateBroadcastMessages < ActiveRecord::Migration
  def change
    create_table :broadcast_messages, force: true do |t|
      t.integer :match_id, null: false
      t.integer :event_id

      t.text :text, null: false

      t.timestamps
    end
  end
end
