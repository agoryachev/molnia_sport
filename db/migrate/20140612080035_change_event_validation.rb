# encoding: utf-8
class ChangeEventValidation < ActiveRecord::Migration
  def change
    change_column :events, :count_home,  :integer, null: true, after: :timestamp
    change_column :events, :count_guest, :integer, null: true, after: :count_home
  end
end
