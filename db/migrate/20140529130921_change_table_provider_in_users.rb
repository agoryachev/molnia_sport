# encoding: utf-8
class ChangeTableProviderInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :provider
    add_column :users, :provider, :string
  end
end
