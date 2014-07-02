# encoding: utf-8
class CreateCharacterTable < ActiveRecord::Migration
  def change
    create_table :characters, force: true do |t|
      t.string :title, comment: 'Название', null: false
    end
  end
end
