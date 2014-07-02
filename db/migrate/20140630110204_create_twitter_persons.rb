# encoding: utf-8
class CreateTwitterPersons < ActiveRecord::Migration
  def change
    create_table :twitter_persons, force: true do |t|
      t.string   :name, null:false, comment: 'имя персоны в твиттер (как идентификатор)'
      t.string   :link, null:false, comment: 'ссылка на твиттер персоны'

      t.timestamps
    end
  end
end
