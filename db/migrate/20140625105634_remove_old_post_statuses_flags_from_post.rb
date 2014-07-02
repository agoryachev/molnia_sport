# encoding: utf-8
class RemoveOldPostStatusesFlagsFromPost < ActiveRecord::Migration
  def up
    remove_column :posts, :is_infograph
    remove_column :posts, :is_live_from_brasilia
  end
end
