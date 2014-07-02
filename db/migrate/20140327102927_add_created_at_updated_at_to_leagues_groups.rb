# encoding: utf-8
class AddCreatedAtUpdatedAtToLeaguesGroups < ActiveRecord::Migration
  def change
    add_column :leagues_groups, :created_at, :datetime
    add_column :leagues_groups, :updated_at, :datetime
  end
end
