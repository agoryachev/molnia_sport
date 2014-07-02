# encoding: utf-8
class AddDateAtToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :date_at, :date, after: :count_guest, null: false, comment: 'Дата проведения матча'
    change_column :matches, :start_at, :time, null: true, comment: 'Время начала матча'
    change_column :matches, :finish_at, :time, null: true, comment: 'Время окончания матча'
  end
end