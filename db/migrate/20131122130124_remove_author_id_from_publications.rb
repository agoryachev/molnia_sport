# encoding: utf-8
class RemoveAuthorIdFromPublications < ActiveRecord::Migration
  def change
    remove_column :galleries, :author_id
    remove_column :posts, :author_id
    remove_column :videos, :author_id
  end
end
