# encoding: utf-8
class AddRefereeIdToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :referee_id, :integer, null: true, after: :leagues_group_id, comment: "Внешний ключ для судьи матча"
  end
end