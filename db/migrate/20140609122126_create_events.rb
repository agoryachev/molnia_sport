# encoding: utf-8
class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events, force: true do |t|
      t.string :name
      t.string :type
      t.integer :player_id
      t.integer :team_id
      t.integer :match_id
      t.integer :player_in_id
      t.integer :player_out_id
      t.integer :card_type
      t.integer :timestamp

      t.timestamps
    end
  end
end
