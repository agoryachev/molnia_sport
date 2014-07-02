# encoding: utf-8
class AddPublishTeamTable < ActiveRecord::Migration
  def change
    create_table :publish_teams, force: true do |t|
      t.string  :publishable_type, comment: 'Полиморфная связь с публикацией'
      t.integer :publishable_id, comment: 'Полиморфная связь с публикацией'
      t.integer :team_id, comment: 'Связь с командой'
    end
    add_index :publish_teams, [:team_id], name: 'polymorphic_many_to_many_idx'
    add_index :publish_teams, [:publishable_id, :publishable_type],           name: 'polymorphic_person_idx'
  end
end