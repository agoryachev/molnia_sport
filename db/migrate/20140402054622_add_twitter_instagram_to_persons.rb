# encoding: utf-8
class AddTwitterInstagramToPersons < ActiveRecord::Migration
  def change
    add_column :persons, :twitter, :string, comment: "Ссылка на twitter", after:"content"
    add_column :persons, :instagram, :string, comment: "Ссылка на instagram", after:"content"
  end
end
