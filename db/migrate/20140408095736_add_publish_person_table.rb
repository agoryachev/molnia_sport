# encoding: utf-8
class AddPublishPersonTable < ActiveRecord::Migration
  def change
    create_table :publish_persons, force: true do |t|
      t.string  :publishable_type, comment: 'Полиморфная связь с публикацией'
      t.integer :publishable_id, comment: 'Полиморфная связь с публикацией'
      t.integer :person_id, comment: 'Связь с игроком'
    end
    add_index :publish_persons, [:person_id], name: 'polymorphic_many_to_many_idx'
    add_index :publish_persons, [:publishable_id, :publishable_type],             name: 'polymorphic_person_idx'
  end
end