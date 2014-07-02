# encoding: utf-8
class CreateInstagramPersons < ActiveRecord::Migration
  def change
    create_table :instagram_persons, force: true do |t|
      t.string   :insta_id,   null:false, comment: 'id персоны в инстаграм (как идентификатор)'
      t.string   :name, null:false,       comment: 'имя персоны в инстаграм'
      t.string   :link, null:false,       comment: 'ссылка на инстаграм персоны'

      t.timestamps
    end
  end
end
