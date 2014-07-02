# encoding: utf-8
class AddProviderUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :integer, comment: 'Название соцсети'
    add_column :users, :uid, :integer, comment: 'uid пользователя в соцсети'
  end
end
