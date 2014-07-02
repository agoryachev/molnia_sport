# encoding: utf-8
class AddYearsTable < ActiveRecord::Migration
  def change
    create_table :years, force: true do |t|
      t.integer :league_year, comment: 'Год'
      t.integer :league_id, comment: 'Связь с лигами'
      t.timestamps
    end
  end
end
