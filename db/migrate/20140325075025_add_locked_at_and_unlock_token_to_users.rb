# encoding: utf-8
class AddLockedAtAndUnlockTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locked_at, :datetime, comment: 'время блокировки пользователя'
    add_column :users, :unlock_token, :string, comment: 'токен разблокировки'
  end
end
