# encoding: utf-8
class AddTimestamp < ActiveRecord::Migration
  def change

    add_column :leagues, :created_at, :datetime, null: false
    add_column :leagues, :updated_at, :datetime, null: false

    add_column :persons, :created_at, :datetime, null: false
    add_column :persons, :updated_at, :datetime, null: false

  end
end