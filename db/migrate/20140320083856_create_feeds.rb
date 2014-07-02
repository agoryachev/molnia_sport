# encoding: utf-8
class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :feedable, polymorphic: true

      t.timestamps
    end
  end
end
