# encoding: utf-8
class AddCreatedAtAndUpdatedAtToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :created_at, :datetime
    add_column :teams, :updated_at, :datetime
  end
end
