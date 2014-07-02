# encoding: utf-8
class AddIsBreaknewsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_breaknews, :boolean, default: false, after: 'is_top', comment: 'Срочная новость'
  end
end
