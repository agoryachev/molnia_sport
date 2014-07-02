# encoding: utf-8
class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities, force: true do |t|
      t.string :context
      t.string :ability_type

      t.timestamps
    end
  end
end
