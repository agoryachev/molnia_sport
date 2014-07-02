# encoding: utf-8
class AddCountsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :count_home, :integer
    add_column :events, :count_guest, :integer
  end
end
