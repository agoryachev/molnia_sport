# encoding: utf-8
class CreateInstagramRecords < ActiveRecord::Migration
  def up
    create_table :instagram_records do |t|
      t.text :data, comment: 'Данные о твите в json'
      t.timestamps
    end
  end
end
