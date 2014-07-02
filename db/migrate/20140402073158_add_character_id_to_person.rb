# encoding: utf-8
class AddCharacterIdToPerson < ActiveRecord::Migration
  def change
    add_column :persons, :character_id, :integer, comment: 'Связь с таблицей character', after: :twitter
  end
end