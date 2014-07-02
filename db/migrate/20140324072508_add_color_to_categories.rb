# encoding: utf-8
class AddColorToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :color, :string, default: 'red_page', comment: 'Гавный цвет категории'
  end
end
