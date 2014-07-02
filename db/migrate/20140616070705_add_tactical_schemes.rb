# encoding: utf-8
class AddTacticalSchemes < ActiveRecord::Migration
  def change
    create_table :tactical_schemes, force: true do |t|
      t.integer :forward,           default: 0, comment: 'Количество нападающих'
      t.integer :halfback,          default: 0, comment: 'Количество полузащитников'
      t.integer :forward_halfback,  default: 0, comment: 'Количество атакующих полузащитников'
      t.integer :defender_halfback, default: 0, comment: 'Количество опорных полузащитников'
      t.integer :defender,          default: 0, comment: 'Количество защитников'
      t.boolean :in_detail,         default: false, comment: 'Подробная расстановка (разбиваются полузащитники)'

      t.timestamps
    end
  end
end
