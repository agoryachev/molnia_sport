# encoding: utf-8
class RemoveUnitsPublicationsTable < ActiveRecord::Migration
  def change
    drop_table :units_publications
  end
end