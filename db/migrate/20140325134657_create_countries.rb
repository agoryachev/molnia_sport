# encoding: utf-8
class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries, force: true do |t|
      t.string :title, comment: 'Название страны'
      t.timestamps
    end
  end
end
