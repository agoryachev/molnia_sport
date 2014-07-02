# encoding: utf-8
class AddNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string, comment: 'Никнейм пользователя'
  end
end
