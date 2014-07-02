# encoding: utf-8
class CreateTeamFormations < ActiveRecord::Migration
  def change
    create_table :team_formations, force: true do |t|
      t.integer   :team_id,     null:false, comment: 'id команды'
      t.integer   :match_id,    null:false, comment: 'id матча'
      t.integer   :person_type, null:false, comment: 'тип игрока (амплуа)'
      t.integer   :person_id,   null:false, comment: 'id игрока'

      t.timestamps
    end
  end
end
