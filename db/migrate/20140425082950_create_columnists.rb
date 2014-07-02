# encoding: utf-8
class CreateColumnists < ActiveRecord::Migration
  def change
    create_table :columnists, comment: 'Колумнисты' do |t|
      t.string :name_first, comment: 'Имя'
      t.string :name_last, comment: 'Фамилия'
      t.string :name_v, comment: 'Отчество'
      t.text :content, comment: 'Описание'

      t.timestamps
    end
  end
end
