# -*- coding: utf-8 -*-
class AddDetailedInfoToPersons < ActiveRecord::Migration
  def change
    add_column :persons, :number,      :integer, null: true, after: :character_id, comment: 'Номер игрока'
    add_column :persons, :height,      :integer, null: true, after: :number,       comment: 'Рост'
    add_column :persons, :weight,      :integer, null: true, after: :height,       comment: 'Вес'
    add_column :persons, :birthday,    :date,    null: true, after: :weight,       comment: 'Дата рождения'
    add_column :persons, :citizenship, :string,  null: true, after: :birthday,     comment: 'Гражданство'
    add_column :persons, :cost,        :string,  null: true, after: :citizenship,  comment: 'Трансферная стоимость'
  end
end
