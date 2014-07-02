# encoding: utf-8
class AddVideosDuration < ActiveRecord::Migration
  def change
    add_column :videos, :duration, :string, after: :content, comment: 'Продолжительность видео в секундах'
  end
end