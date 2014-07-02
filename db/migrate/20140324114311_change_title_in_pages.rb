# encoding: utf-8
class ChangeTitleInPages < ActiveRecord::Migration
  def change
    change_column :pages, :title, :string, null: false, default: ''
    set_column_comment :pages, :title, 'Заголовок страницы'
  end
end
