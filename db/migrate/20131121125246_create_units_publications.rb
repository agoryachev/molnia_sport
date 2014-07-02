# encoding: utf-8
class CreateUnitsPublications < ActiveRecord::Migration
  def change

    create_table :units_publications, comment: "Связующая таблица спортивных единиц (Team, Person, Match, League, Transfer) и публикации (Post, Video, Gallery)" do |t|

      t.references :unitable, unsigned: true, null: false, polymorphic: true, comment: "Внешний ключ для спортивных единиц (Team, Person, Match, League, Transfer)"
      t.references :publicatable, unsigned: true, null: false, polymorphic: true, comment: "Внешний ключ для публикации (Post, Video, Gallery)"

    end

  end
end