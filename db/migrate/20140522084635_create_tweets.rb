# encoding: utf-8
class CreateTweets < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.text :data, comment: 'Данные о твите в json'
      t.timestamps
    end
  end
end
