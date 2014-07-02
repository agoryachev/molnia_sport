# encoding: utf-8
class RenameDateToDateAtInLeagues < ActiveRecord::Migration
  def change
    rename_column :leagues, :date, :date_at
    set_column_comment :leagues, :date_at, 'Год проведения чемпионата'
  end
end
